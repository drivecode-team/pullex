/*
    Based on original work by Jpeng (peng8350@gmail.com)
    Original repository: https://github.com/xxzj990-game/flutter_pulltorefresh

    Modified and maintained by Drivecode Team
    Modifications include bug fixes, refactoring, enhancements
    This file is part of the pullex package.
 */

import 'dart:async';

import 'package:flutter/material.dart'
    hide RefreshIndicatorState, RefreshIndicator;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pullex/src/internal/indicator_wrap.dart';
import 'package:pullex/pullex.dart';

/// QQ iOS refresh header effect
class WaterDropHeader extends RefreshIndicator {
  final Widget? refresh;
  final Widget? complete;
  final Widget? failed;
  final Widget idleIcon;
  final Color waterDropColor;

  const WaterDropHeader({
    Key? key,
    this.refresh,
    this.complete,
    Duration completeDuration = const Duration(milliseconds: 600),
    this.failed,
    this.waterDropColor = Colors.grey,
    this.idleIcon = const Icon(
      Icons.autorenew,
      size: 15,
      color: Colors.white,
    ),
  }) : super(
          key: key,
          height: 60.0,
          completeDuration: completeDuration,
          refreshStyle: RefreshStyle.unFollow,
        );

  @override
  State<StatefulWidget> createState() => _WaterDropHeaderState();
}

class _WaterDropHeaderState extends RefreshIndicatorState<WaterDropHeader>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final AnimationController _dismissCtl;

  @override
  void initState() {
    _dismissCtl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 1.0,
    );
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 50.0,
      duration: const Duration(milliseconds: 400),
    );
    super.initState();
  }

  @override
  void onOffsetChange(double offset) {
    final double realOffset = offset - 44.0;
    if (!_animationController.isAnimating) {
      _animationController.value = realOffset;
    }
  }

  @override
  Future<void> readyToRefresh() {
    _dismissCtl.animateTo(0.0);
    return _animationController.animateTo(0.0);
  }

  @override
  bool needReverseAll() => false;

  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    Widget? child;

    if (mode == RefreshStatus.refreshing) {
      child = widget.refresh ??
          SizedBox(
            width: 25.0,
            height: 25.0,
            child: defaultTargetPlatform == TargetPlatform.iOS
                ? const CupertinoActivityIndicator()
                : const CircularProgressIndicator(strokeWidth: 2.0),
          );
    } else if (mode == RefreshStatus.completed) {
      child = widget.complete ??
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.done, color: Colors.grey),
              const SizedBox(width: 15.0),
              Text(
                (PullexLocalizations.of(context)?.currentLocalization ??
                        EnRefreshString())
                    .refreshCompleteText!,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          );
    } else if (mode == RefreshStatus.failed) {
      child = widget.failed ??
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.close, color: Colors.grey),
              const SizedBox(width: 15.0),
              Text(
                (PullexLocalizations.of(context)?.currentLocalization ??
                        EnRefreshString())
                    .refreshFailedText!,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          );
    } else if (mode == RefreshStatus.idle || mode == RefreshStatus.canRefresh) {
      final alignment = Scrollable.of(context).axisDirection == AxisDirection.up
          ? Alignment.bottomCenter
          : Alignment.topCenter;
      final margin = Scrollable.of(context).axisDirection == AxisDirection.up
          ? const EdgeInsets.only(bottom: 12.0)
          : const EdgeInsets.only(top: 12.0);

      return FadeTransition(
        opacity: _dismissCtl,
        child: Container(
          height: 60.0,
          child: Stack(
            children: [
              RotatedBox(
                quarterTurns:
                    Scrollable.of(context).axisDirection == AxisDirection.up
                        ? 10
                        : 0,
                child: CustomPaint(
                  painter: _QqPainter(
                    color: widget.waterDropColor,
                    listener: _animationController,
                  ),
                  child: Container(height: 60.0),
                ),
              ),
              Container(
                alignment: alignment,
                margin: margin,
                child: widget.idleIcon,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 60.0,
      child: Center(child: child),
    );
  }

  @override
  void resetValue() {
    _animationController.reset();
    _dismissCtl.value = 1.0;
  }

  @override
  void dispose() {
    _dismissCtl.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

class _QqPainter extends CustomPainter {
  final Color? color;
  final Animation<double>? listener;

  double get value => listener!.value;

  final Paint _painter = Paint();

  _QqPainter({this.color, this.listener}) : super(repaint: listener);

  @override
  void paint(Canvas canvas, Size size) {
    const double originH = 20.0;
    final double middleW = size.width / 2;
    const double circleSize = 12.0;
    const double scaleRatio = 0.1;
    final double offset = value;

    _painter.color = color!;

    canvas.drawCircle(Offset(middleW, originH), circleSize, _painter);

    Path path = Path();
    path.moveTo(middleW - circleSize, originH);

    // Left curve
    path.cubicTo(
      middleW - circleSize,
      originH,
      middleW - circleSize + offset * scaleRatio,
      originH + offset / 5,
      middleW - circleSize + offset * scaleRatio * 2,
      originH + offset,
    );

    path.lineTo(
      middleW + circleSize - offset * scaleRatio * 2,
      originH + offset,
    );

    // Right curve
    path.cubicTo(
      middleW + circleSize - offset * scaleRatio * 2,
      originH + offset,
      middleW + circleSize - offset * scaleRatio,
      originH + offset / 5,
      middleW + circleSize,
      originH,
    );

    // Upper circle
    path.moveTo(middleW - circleSize, originH);
    path.arcToPoint(
      Offset(middleW + circleSize, originH),
      radius: Radius.circular(circleSize),
    );

    // Lower circle
    path.moveTo(
      middleW + circleSize - offset * scaleRatio * 2,
      originH + offset,
    );
    path.arcToPoint(
      Offset(middleW - circleSize + offset * scaleRatio * 2, originH + offset),
      radius: Radius.circular(offset * scaleRatio),
    );

    path.close();
    canvas.drawPath(path, _painter);
  }

  @override
  bool shouldRepaint(_QqPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
