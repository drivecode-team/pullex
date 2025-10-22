/*
    Based on original work by Jpeng (peng8350@gmail.com)
    Original repository: https://github.com/xxzj990-game/flutter_pulltorefresh

    Modified and maintained by Drivecode Team
    Modifications include bug fixes, refactoring, enhancements
    This file is part of the pullex package.
*/

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicatorState, RefreshIndicator;
import 'package:pullex/src/internal/indicator_wrap.dart';
import 'package:pullex/pullex.dart';

/// Custom header builder. You can use the second parameter to know what header state is.
typedef HeaderBuilder = Widget Function(BuildContext context, RefreshStatus? mode);

/// Custom footer builder. You can use the second parameter to know what footer state is.
typedef FooterBuilder = Widget Function(BuildContext context, LoadStatus? mode);

/// A custom Indicator for header.
///
/// Here is a simple usage:
///
/// ```dart
/// CustomHeader(
///   builder: (context, mode) {
///     Widget body;
///     if (mode == RefreshStatus.idle) {
///       body = Text("pull down refresh");
///     } else if (mode == RefreshStatus.refreshing) {
///       body = CupertinoActivityIndicator();
///     } else if (mode == RefreshStatus.canRefresh) {
///       body = Text("release to refresh");
///     } else if (mode == RefreshStatus.completed) {
///       body = Text("refreshCompleted!");
///     }
///     return Container(
///       height: 60.0,
///       child: Center(child: body),
///     );
///   },
/// )
/// ```
///
/// If you need to listen to overScroll event and perform animations, use [onOffsetChange] callback.
/// For more complex indicators, extend [RefreshIndicator].
///
/// See also:
/// - [CustomFooter], a custom Indicator for footer.
class CustomHeader extends RefreshIndicator {
  final HeaderBuilder builder;
  final VoidFutureCallBack? readyToRefresh;
  final VoidFutureCallBack? endRefresh;
  final OffsetCallBack? onOffsetChange;
  final ModeChangeCallBack<RefreshStatus>? onModeChange;
  final VoidCallback? onResetValue;

  const CustomHeader({
    Key? key,
    required this.builder,
    this.readyToRefresh,
    this.endRefresh,
    this.onOffsetChange,
    this.onModeChange,
    this.onResetValue,
    double height = 60.0,
    Duration completeDuration = const Duration(milliseconds: 600),
    RefreshStyle refreshStyle = RefreshStyle.Follow,
  }) : super(
    key: key,
    completeDuration: completeDuration,
    refreshStyle: refreshStyle,
    height: height,
  );

  @override
  State<StatefulWidget> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends RefreshIndicatorState<CustomHeader> {
  @override
  void onOffsetChange(double offset) {
    widget.onOffsetChange?.call(offset);
    super.onOffsetChange(offset);
  }

  @override
  void onModeChange(RefreshStatus? mode) {
    widget.onModeChange?.call(mode);
    super.onModeChange(mode);
  }

  @override
  Future<void> readyToRefresh() {
    if (widget.readyToRefresh != null) {
      return widget.readyToRefresh!();
    }
    return super.readyToRefresh();
  }

  @override
  Future<void> endRefresh() {
    if (widget.endRefresh != null) {
      return widget.endRefresh!();
    }
    return super.endRefresh();
  }

  @override
  void resetValue() {
    widget.onResetValue?.call();
    super.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    return widget.builder(context, mode);
  }
}

/// A custom Indicator for footer.
/// Usage is similar to [CustomHeader].
///
/// See also:
/// - [CustomHeader], a custom Indicator for header.
class CustomFooter extends LoadIndicator {
  final FooterBuilder builder;
  final OffsetCallBack? onOffsetChange;
  final ModeChangeCallBack<LoadStatus>? onModeChange;
  final VoidFutureCallBack? readyLoading;
  final VoidFutureCallBack? endLoading;
  final VoidCallback? onResetValue;
  final VoidCallback? onClick;

  const CustomFooter({
    Key? key,
    required this.builder,
    this.onOffsetChange,
    this.onModeChange,
    this.readyLoading,
    this.endLoading,
    this.onResetValue,
    this.onClick,
    double height = 60.0,
    LoadStyle loadStyle = LoadStyle.ShowAlways,
  }) : super(
    key: key,
    loadStyle: loadStyle,
    height: height,
    onClick: onClick,
  );

  @override
  State<StatefulWidget> createState() => _CustomFooterState();
}

class _CustomFooterState extends LoadIndicatorState<CustomFooter> {
  @override
  void onOffsetChange(double offset) {
    widget.onOffsetChange?.call(offset);
    super.onOffsetChange(offset);
  }

  @override
  void onModeChange(LoadStatus? mode) {
    widget.onModeChange?.call(mode);
    super.onModeChange(mode);
  }

  @override
  Future<void> readyToLoad() {
    if (widget.readyLoading != null) {
      return widget.readyLoading!();
    }
    return super.readyToLoad();
  }

  @override
  Future<void> endLoading() {
    if (widget.endLoading != null) {
      return widget.endLoading!();
    }
    return super.endLoading();
  }

  @override
  void resetValue() {
    widget.onResetValue?.call();
    super.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, LoadStatus? mode) {
    return widget.builder(context, mode);
  }
}
