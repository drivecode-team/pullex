/*
    Based on original work by Jpeng (peng8350@gmail.com)
    Original repository: https://github.com/xxzj990-game/flutter_pulltorefresh

    Modified and maintained by Drivecode Team
    Modifications include bug fixes, refactoring, enhancements
    This file is part of the pullex package.
 */


import 'package:flutter/material.dart'
    hide RefreshIndicatorState, RefreshIndicator;
import 'package:flutter/physics.dart';
import 'package:pullex/pullex.dart';
import 'package:pullex/src/internal/indicator_wrap.dart';
import 'dart:math' as math;

enum StretchDismissType { none, rectSpread, scaleToCenter }

enum StretchCircleType { radial, progress }

/// stretch container, if you need to implement indicator with stretch, you can consider using this.
/// this will add the stretch container effect
///
/// See also:
///
/// [StretchCircleHeader], stretch container + circle progress indicator
class StretchHeader extends RefreshIndicator {
  final OffsetCallBack? onOffsetChange;
  final ModeChangeCallBack? onModeChange;
  final VoidFutureCallBack? readyRefresh, endRefresh;
  final VoidCallback? onResetValue;
  final Color? stretchColor;
  final StretchDismissType dismissType;
  final bool enableChildOverflow;
  final Widget child;
  final double rectHeight;

  StretchHeader({
    this.child = const Text(""),
    this.onOffsetChange,
    this.onModeChange,
    this.readyRefresh,
    this.enableChildOverflow = false,
    this.endRefresh,
    this.onResetValue,
    this.dismissType = StretchDismissType.rectSpread,
    this.rectHeight = 70,
    this.stretchColor,
  }) : super(refreshStyle: RefreshStyle.unFollow, height: rectHeight);

  @override
  State<StatefulWidget> createState() => _StretchHeaderState();
}

class _StretchHeaderState extends RefreshIndicatorState<StretchHeader>
    with TickerProviderStateMixin {
  late AnimationController _stretchBounceCtl, _stretchDismissCtl;

  @override
  void initState() {
    _stretchBounceCtl = AnimationController(
      vsync: this,
      lowerBound: -10,
      upperBound: 50,
      value: 0,
    );
    _stretchDismissCtl = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant StretchHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dismissType != widget.dismissType) {
      setState(() {}); // force rebuild → AnimatedBuilder перемалює ClipPath
    }
  }

  @override
  void onOffsetChange(double offset) {
    if (widget.onOffsetChange != null) {
      widget.onOffsetChange!(offset);
    }
    if (!_stretchBounceCtl.isAnimating || (!floating)) {
      _stretchBounceCtl.value = math.max(0, offset - widget.rectHeight);
    }
  }

  @override
  void onModeChange(RefreshStatus? mode) {
    if (widget.onModeChange != null) {
      widget.onModeChange!(mode);
    }
    super.onModeChange(mode);
  }

  @override
  void dispose() {
    _stretchDismissCtl.dispose();
    _stretchBounceCtl.dispose();
    super.dispose();
  }

  @override
  Future<void> readyToRefresh() {
    final Simulation simulation = SpringSimulation(
      SpringDescription(
        mass: 3.4,
        stiffness: 10000.5,
        damping: 6,
      ),
      _stretchBounceCtl.value,
      0,
      1000,
    );
    _stretchBounceCtl.animateWith(simulation);
    if (widget.readyRefresh != null) {
      return widget.readyRefresh!();
    }
    return super.readyToRefresh();
  }

  @override
  Future<void> endRefresh() async {
    if (widget.endRefresh != null) {
      await widget.endRefresh!();
    }
    return _stretchDismissCtl.animateTo(
      1.0,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void resetValue() {
    _stretchDismissCtl.reset();
    _stretchBounceCtl.value = 0;
    if (widget.onResetValue != null) {
      widget.onResetValue!();
    }
    super.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    return AnimatedBuilder(
      builder: (_, __) {
        return Stack(
          children: <Widget>[
            Positioned(
              child: AnimatedBuilder(
                builder: (_, __) {
                  return ClipPath(
                    child: ClipPath(
                      child: Container(
                        height: widget.rectHeight + 30,
                        color: widget.stretchColor ??
                            Theme.of(context).primaryColor,
                      ),
                      clipper: _StretchPainter(
                        value: _stretchBounceCtl.value,
                        startOffsetY: widget.rectHeight,
                      ),
                    ),
                    clipper: _StretchDismissPainter(
                      value: _stretchDismissCtl.value,
                      dismissType: widget.dismissType,
                    ),
                  );
                },
                animation: _stretchDismissCtl,
              ),
              bottom: -50,
              top: 0,
              left: 0,
              right: 0,
            ),
            !widget.enableChildOverflow
                ? ClipRect(
              child: Container(
                height: (_stretchBounceCtl.isAnimating ||
                    mode == RefreshStatus.refreshing
                    ? 0
                    : math.max(0, _stretchBounceCtl.value)) +
                    widget.rectHeight,
                child: widget.child,
              ),
            )
                : Container(
              height: (_stretchBounceCtl.isAnimating ||
                  mode == RefreshStatus.refreshing
                  ? 0
                  : math.max(0, _stretchBounceCtl.value)) +
                  widget.rectHeight,
              child: widget.child,
            ),
          ],
        );
      },
      animation: _stretchBounceCtl,
    );
  }
}

class _StretchDismissPainter extends CustomClipper<Path> {
  final StretchDismissType? dismissType;
  final double? value;

  _StretchDismissPainter({this.dismissType, this.value});

  @override
  Path getClip(Size size) {
    Path path = Path();
    if (dismissType == StretchDismissType.none || value == 0) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(0, 0);
    } else if (dismissType == StretchDismissType.rectSpread) {
      Path path1 = Path();
      Path path2 = Path();
      double halfWidth = size.width / 2;
      path1.moveTo(0, 0);
      path1.lineTo(halfWidth - value! * halfWidth, 0);
      path1.lineTo(halfWidth - value! * halfWidth, size.height);
      path1.lineTo(0, size.height);
      path1.lineTo(0, 0);

      path2.moveTo(size.width, 0);
      path2.lineTo(halfWidth + value! * halfWidth, 0);
      path2.lineTo(halfWidth + value! * halfWidth, size.height);
      path2.lineTo(size.width, size.height);
      path2.lineTo(size.width, 0);
      path.addPath(path1, Offset.zero);
      path.addPath(path2, Offset.zero);
    } else {
      final double maxExtent =
          math.max(size.width, size.height) * (1.0 - value!);
      final double centerX = size.width / 2;
      final double centerY = size.height / 2;
      path.addOval(Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: maxExtent / 2,
      ));
    }
    return path;
  }

  @override
  bool shouldReclip(_StretchDismissPainter oldClipper) {
    return dismissType != oldClipper.dismissType || value != oldClipper.value;
  }
}

class _StretchPainter extends CustomClipper<Path> {
  final double? startOffsetY;
  final double? value;

  _StretchPainter({this.value, this.startOffsetY});

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, startOffsetY!);
    path.quadraticBezierTo(
      size.width / 2,
      startOffsetY! + value! * 2,
      size.width,
      startOffsetY!,
    );
    path.moveTo(size.width, startOffsetY!);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(_StretchPainter oldClipper) {
    return value != oldClipper.value;
  }
}

/// stretch + circle indicator, you can use this directly
///
/// simple usage
/// ```dart
/// header: StretchCircleHeader(
///   stretchColor: Colors.red,
///   circleColor: Colors.amber,
///   dismissType: StretchDismissType.ScaleToCenter,
///   circleType: StretchCircleType.Raidal,
/// )
/// ```
class StretchCircleHeader extends StatefulWidget {
  final Color? stretchColor;
  final StretchCircleType circleType;
  final double rectHeight;
  final Color circleColor;
  final double circleRadius;
  final bool enableChildOverflow;
  final StretchDismissType dismissType;

  /// Duration of one full rotation in Raidal animation
  final Duration radialRotationDuration;

  StretchCircleHeader({
    this.stretchColor,
    this.rectHeight = 70,
    this.circleColor = Colors.white,
    this.enableChildOverflow = false,
    this.dismissType = StretchDismissType.rectSpread,
    this.circleType = StretchCircleType.progress,
    this.circleRadius = 12,
    this.radialRotationDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<StatefulWidget> createState() => _StretchCircleHeaderState();
}

class _StretchCircleHeaderState extends State<StretchCircleHeader>
    with TickerProviderStateMixin {
  static const double _rotationAngle = math.pi * 2;

  RefreshStatus mode = RefreshStatus.idle;
  late AnimationController _childMoveCtl;
  late Tween<Alignment> _childMoveTween;
  late AnimationController _dismissCtrl;
  late Tween<Offset> _disMissTween;
  late AnimationController _radialCtrl;

  @override
  void initState() {
    _dismissCtrl = AnimationController(vsync: this);
    _childMoveCtl = AnimationController(vsync: this);
    _radialCtrl = AnimationController(
      vsync: this,
      duration: widget.radialRotationDuration,
    );
    _childMoveTween = Tween<Alignment>(
      begin: Alignment.bottomCenter,
      end: Alignment.center,
    );
    _disMissTween = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 1.5),
    );
    super.initState();
  }

  @override
  void dispose() {
    _dismissCtrl.dispose();
    _childMoveCtl.dispose();
    _radialCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StretchHeader(
      stretchColor: widget.stretchColor,
      rectHeight: widget.rectHeight,
      dismissType: widget.dismissType,
      enableChildOverflow: widget.enableChildOverflow,
      readyRefresh: () async {
        await _childMoveCtl.animateTo(
          1.0,
          duration: const Duration(milliseconds: 300),
        );
      },
      onResetValue: () {
        _dismissCtrl.value = 0;
        _childMoveCtl.reset();
      },
      onModeChange: (m) {
        mode = m;
        if (m == RefreshStatus.refreshing) {
          _radialCtrl.repeat(); // Use duration from controller
        }
        setState(() {});
      },
      endRefresh: () async {
        _radialCtrl.reset();
        await _dismissCtrl.animateTo(
          1,
          duration: const Duration(milliseconds: 550),
        );
      },
      child: SlideTransition(
        position: _disMissTween.animate(_dismissCtrl),
        child: AlignTransition(
          child: widget.circleType == StretchCircleType.progress
              ? Container(
            height: widget.circleRadius * 2 + 5,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    height: widget.circleRadius * 2,
                    decoration: BoxDecoration(
                      color: widget.circleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(
                      valueColor: mode == RefreshStatus.refreshing
                          ? AlwaysStoppedAnimation(widget.circleColor)
                          : AlwaysStoppedAnimation(Colors.transparent),
                      strokeWidth: 2,
                    ),
                    height: widget.circleRadius * 2 + 5,
                    width: widget.circleRadius * 2 + 5,
                  ),
                ),
              ],
            ),
          )
              : AnimatedBuilder(
            builder: (_, __) {
              return Container(
                height: widget.circleRadius * 2,
                child: CustomPaint(
                  painter: _RaidalPainter(
                    value: _radialCtrl.value,
                    circleColor: widget.circleColor,
                    circleRadius: widget.circleRadius,
                    refreshing: mode == RefreshStatus.refreshing,
                    rotationAngle: _rotationAngle,
                  ),
                ),
              );
            },
            animation: _radialCtrl,
          ),
          alignment: _childMoveCtl.drive(_childMoveTween),
        ),
      ),
    );
  }
}

class _RaidalPainter extends CustomPainter {
  final double? value;
  final Color? circleColor;
  final double? circleRadius;
  final bool? refreshing;
  final double rotationAngle;

  _RaidalPainter({
    required this.value,
    required this.circleColor,
    required this.circleRadius,
    required this.refreshing,
    required this.rotationAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = circleColor!;
    paint.strokeWidth = 2;
    paint.strokeCap = StrokeCap.round;
    paint.style = PaintingStyle.stroke;
    if (refreshing!) {
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: circleRadius! + 3,
        ),
        -math.pi / 2,
        rotationAngle,
        false,
        paint,
      );
    }
    paint.style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: circleRadius!,
      ),
      -math.pi / 2,
      rotationAngle,
      true,
      paint,
    );
    paint.color = const Color.fromRGBO(233, 233, 233, 0.8);
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: circleRadius!,
      ),
      -math.pi / 2,
      rotationAngle * value!,
      true,
      paint,
    );
    paint.style = PaintingStyle.stroke;
    if (refreshing!) {
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: circleRadius! + 3,
        ),
        -math.pi / 2,
        rotationAngle * value!,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RaidalPainter oldDelegate) {
    return value != oldDelegate.value ||
        rotationAngle != oldDelegate.rotationAngle;
  }
}