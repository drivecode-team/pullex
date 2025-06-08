/*
    Based on original work by Jpeng (peng8350@gmail.com)
    Original repository: https://github.com/xxzj990-game/flutter_pulltorefresh

    Modified and maintained by Drivecode Team
    Modifications include bug fixes, refactoring, enhancements
    This file is part of the pullex package.
*/

import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:pullex/pullex.dart';
import 'package:pullex/src/internal/indicator_wrap.dart';

// Constants
const double _kDragSizeFactorLimit = 1.5;
const double _defaultHeaderHeight = 80.0;
const double _waterDropHeight = 100.0;

class MaterialHeader extends RefreshIndicator {
  final String? semanticsLabel;
  final String? semanticsValue;
  final Color? color;
  final double distance;
  final Color? backgroundColor;

  const MaterialHeader({
    Key? key,
    double height = _defaultHeaderHeight,
    this.semanticsLabel,
    this.semanticsValue,
    this.color,
    double offset = 0,
    this.distance = 50.0,
    this.backgroundColor,
  }) : super(
    key: key,
    refreshStyle: RefreshStyle.Front,
    offset: offset,
    height: height,
  );

  @override
  State<StatefulWidget> createState() => _MaterialHeaderState();
}

class _MaterialHeaderState
    extends RefreshIndicatorState<MaterialHeader>
    with TickerProviderStateMixin {
  ScrollPosition? _position;
  Animation<Offset>? _positionFactor;
  Animation<Color?>? _valueColor;
  late AnimationController _scaleFactor;
  late AnimationController _positionController;
  late AnimationController _valueAni;

  @override
  void initState() {
    super.initState();
    _valueAni = AnimationController(
      vsync: this,
      value: 0.0,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
      if (mounted && _position != null && _position!.pixels <= 0) setState(() {});
    });

    _positionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleFactor = AnimationController(
      vsync: this,
      value: 1.0,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: const Duration(milliseconds: 300),
    );

    _positionFactor = _positionController.drive(
      Tween<Offset>(
        begin: const Offset(0.0, -1.0),
        end: Offset(0.0, widget.height / 44.0),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant MaterialHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    _position = Scrollable.of(context).position;
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    return _buildIndicator(widget.backgroundColor ?? Colors.white);
  }

  Widget _buildIndicator(Color outerColor) {
    return SlideTransition(
      position: _positionFactor!,
      child: ScaleTransition(
        scale: _scaleFactor,
        child: Align(
          alignment: Alignment.topCenter,
          child: RefreshProgressIndicator(
            semanticsLabel: widget.semanticsLabel ??
                MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
            semanticsValue: widget.semanticsValue,
            value: floating ? null : _valueAni.value,
            valueColor: _valueColor,
            backgroundColor: outerColor,
          ),
        ),
      ),
    );
  }

  @override
  void onOffsetChange(double offset) {
    if (!floating) {
      _valueAni.value = offset / configuration!.headerTriggerDistance;
      _positionController.value = offset / configuration!.headerTriggerDistance;
    }
  }

  @override
  void onModeChange(RefreshStatus? mode) {
    if (mode == RefreshStatus.refreshing) {
      _positionController.value = widget.distance / widget.height;
      _scaleFactor.value = 1;
    }
    super.onModeChange(mode);
  }

  @override
  void resetValue() {
    _scaleFactor.value = 1.0;
    _positionController.value = 0.0;
    _valueAni.value = 0.0;
    super.resetValue();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ThemeData theme = Theme.of(context);
    _position = Scrollable.of(context).position;

    _valueColor = _positionController.drive(
      ColorTween(
        begin: (widget.color ?? theme.primaryColor).withOpacity(0.0),
        end: (widget.color ?? theme.primaryColor).withOpacity(1.0),
      ).chain(
        CurveTween(
          curve: const Interval(0.0, 1.0 / _kDragSizeFactorLimit),
        ),
      ),
    );
  }

  @override
  Future<void> readyToRefresh() {
    return _positionController.animateTo(widget.distance / widget.height);
  }

  @override
  Future<void> endRefresh() {
    return _scaleFactor.animateTo(0.0);
  }

  @override
  void dispose() {
    _valueAni.dispose();
    _scaleFactor.dispose();
    _positionController.dispose();
    super.dispose();
  }
}

class WaterDropMaterialHeader extends MaterialHeader {
  const WaterDropMaterialHeader({
    Key? key,
    String? semanticsLabel,
    double distance = 60.0,
    double offset = 0,
    String? semanticsValue,
    Color color = Colors.white,
    Color? backgroundColor,
  }) : super(
    key: key,
    height: _defaultHeaderHeight,
    color: color,
    distance: distance,
    offset: offset,
    backgroundColor: backgroundColor,
    semanticsValue: semanticsValue,
    semanticsLabel: semanticsLabel,
  );

  @override
  State<StatefulWidget> createState() => _WaterDropMaterialHeaderState();
}

class _WaterDropMaterialHeaderState extends _MaterialHeaderState {
  late AnimationController _bezierController;
  bool _showWater = false;

  @override
  void initState() {
    super.initState();

    _bezierController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      upperBound: 1.5,
      lowerBound: 0.0,
      value: 0.0,
    );

    _positionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      upperBound: 1.0,
      lowerBound: 0.0,
      value: 0.0,
    );

    _positionFactor = _positionController.drive(
      Tween<Offset>(
        begin: const Offset(0.0, -0.5),
        end: const Offset(0.0, 1.5),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ThemeData theme = Theme.of(context);
    _valueColor = _positionController.drive(
      ColorTween(
        begin: (widget.color ?? theme.primaryColor).withOpacity(0.0),
        end: (widget.color ?? theme.primaryColor).withOpacity(1.0),
      ).chain(
        CurveTween(
          curve: const Interval(0.0, 1.0 / _kDragSizeFactorLimit),
        ),
      ),
    );
  }

  @override
  Future<void> readyToRefresh() {
    _bezierController.value = 1.01;
    _showWater = true;

    _bezierController.animateTo(
      1.5,
      curve: Curves.bounceOut,
      duration: const Duration(milliseconds: 550),
    );

    return _positionController
        .animateTo(
      widget.distance / widget.height,
      curve: Curves.bounceOut,
      duration: const Duration(milliseconds: 550),
    )
        .then((_) {
      _showWater = false;
    });
  }

  @override
  Future<void> endRefresh() {
    _showWater = false;
    return super.endRefresh();
  }

  @override
  void resetValue() {
    _bezierController.reset();
    super.resetValue();
  }

  @override
  void dispose() {
    _bezierController.dispose();
    super.dispose();
  }

  @override
  void onOffsetChange(double offset) {
    offset = offset > _defaultHeaderHeight ? _defaultHeaderHeight : offset;

    if (!floating) {
      _bezierController.value = offset / configuration!.headerTriggerDistance;
      _valueAni.value = _bezierController.value;
      _positionController.value = _bezierController.value * 0.3;
      _scaleFactor.value = offset < 40.0
          ? 0.0
          : (_bezierController.value - 0.5) * 2 + 0.5;
    }
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    final Color color =
        widget.backgroundColor ?? Theme.of(context).primaryColor;

    return SizedBox(
      height: _waterDropHeight,
      child: Stack(
        children: <Widget>[
          CustomPaint(
            painter: _StretchPainter(
              listener: _bezierController,
              color: color,
            ),
            child: Container(),
          ),
          CustomPaint(
            painter: _showWater
                ? _WaterPainter(
              ratio: widget.distance / widget.height,
              color: color,
              listener: _positionFactor,
            )
                : null,
            child: _buildIndicator(color),
          ),
        ],
      ),
    );
  }
}

class _WaterPainter extends CustomPainter {
  final Color? color;
  final Animation<Offset>? listener;
  final double? ratio;

  Offset get offset => listener!.value;

  _WaterPainter({this.color, this.listener, this.ratio})
      : super(repaint: listener);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color!;
    final Path path = Path();

    path.moveTo(size.width / 2 - 20.0, offset.dy * 100.0 + 20.0);
    path.conicTo(
      size.width / 2,
      offset.dy * 100.0 - 70.0 * (ratio! - offset.dy),
      size.width / 2 + 20.0,
      offset.dy * 100.0 + 20.0,
      10.0 * (ratio! - offset.dy),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WaterPainter oldDelegate) {
    return oldDelegate.offset != offset || oldDelegate.color != color;
  }
}

class _StretchPainter extends CustomPainter {
  final AnimationController? listener;
  final Color? color;

  double get value => listener!.value;

  _StretchPainter({this.listener, this.color}) : super(repaint: listener);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color!;
    final Path path = Path();
    final double middleX = size.width / 2;

    if (value < 0.5) {
      path.moveTo(0.0, 0.0);
      path.quadraticBezierTo(middleX, 70.0 * value, size.width, 0.0);
    } else if (value <= 1.0) {
      final double offsetY = 60.0 * (value - 0.5) + 20.0;
      path.moveTo(0.0, 0.0);
      path.quadraticBezierTo(
        middleX + 40.0 * (value - 0.5),
        40.0 - 40.0 * value,
        middleX - 10.0,
        offsetY,
      );
      path.lineTo(middleX + 10.0, offsetY);
      path.quadraticBezierTo(
        middleX - 40.0 * (value - 0.5),
        40.0 - 40.0 * value,
        size.width,
        0.0,
      );
      path.lineTo(0.0, 0.0);
    } else {
      path.moveTo(0.0, 0.0);
      path.conicTo(
        middleX,
        60.0 * (1.5 - value),
        size.width,
        0.0,
        5.0,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StretchPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}