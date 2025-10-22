/*
    Based on original work by Jpeng (peng8350@gmail.com)
    Original repository: https://github.com/xxzj990-game/flutter_pulltorefresh

    Modified and maintained by Drivecode Team
    Modifications include bug fixes, refactoring, enhancements
    This file is part of the pullex package.
 */

import 'package:flutter/widgets.dart';
import 'package:pullex/src/refresh/pullex_refresh.dart';

/// Configuration for PullexRefresh widgets in the subtree.
/// Works similarly to [ScrollConfiguration], provides global defaults for indicators and behaviors.
///
/// See also:
/// * [PullexRefresh], a widget to easily attach pull-to-refresh and load-more functionality.
class RefreshConfiguration extends InheritedWidget {
  /// Global default header builder
  final IndicatorBuilder? headerBuilder;

  /// Global default footer builder
  final IndicatorBuilder? footerBuilder;

  /// Custom spring animation for scrolling
  final SpringDescription springDescription;

  /// If true, refresh is triggered immediately when reaching trigger distance
  final bool skipCanRefresh;

  /// Determines whether footer should follow content when not full
  final ShouldFollowContent? shouldFooterFollowWhenNotFull;

  /// Hides footer if content is not full
  final bool hideFooterWhenNotFull;

  /// Enables scrolling while two-level view is open
  final bool enableScrollWhenTwoLevel;

  /// Enables scrolling while refresh completes and springs back
  final bool enableScrollWhenRefreshCompleted;

  /// Enables refresh triggered by ballistic scroll activity
  final bool enableBallisticRefresh;

  /// Enables loading triggered by ballistic scroll activity
  final bool enableBallisticLoad;

  /// Enables loading when footer is in failed state
  final bool enableLoadingWhenFailed;

  /// Enables loading when footer is in no-more-data state
  final bool enableLoadingWhenNoData;

  /// Distance required to trigger refresh
  final double headerTriggerDistance;

  /// Distance required to trigger two-level
  final double twiceTriggerDistance;

  /// Distance to close two-level view (only if enableScrollWhenTwoLevel is true)
  final double closeTwoLevelDistance;

  /// Distance required to trigger loading
  final double footerTriggerDistance;

  /// Drag speed multiplier when overscrolling
  final double dragSpeedRatio;

  /// Max overscroll distance
  final double? maxOverScrollExtent;

  /// Max underscroll distance
  final double? maxUnderScrollExtent;

  /// Top hit boundary for inertia scrolling
  final double? topHitBoundary;

  /// Bottom hit boundary for inertia scrolling
  final double? bottomHitBoundary;

  /// Enables vibration when refresh is triggered
  final bool enableRefreshVibrate;

  /// Enables vibration when load-more is triggered
  final bool enableLoadMoreVibrate;

  const RefreshConfiguration({
    Key? key,
    required Widget child,
    this.headerBuilder,
    this.footerBuilder,
    this.dragSpeedRatio = 1.0,
    this.shouldFooterFollowWhenNotFull,
    this.enableScrollWhenTwoLevel = true,
    this.enableLoadingWhenNoData = false,
    this.enableBallisticRefresh = false,
    this.springDescription = const SpringDescription(
      mass: 2.2,
      stiffness: 150,
      damping: 16,
    ),
    this.enableScrollWhenRefreshCompleted = false,
    this.enableLoadingWhenFailed = true,
    this.twiceTriggerDistance = 150.0,
    this.closeTwoLevelDistance = 80.0,
    this.skipCanRefresh = false,
    this.maxOverScrollExtent,
    this.enableBallisticLoad = true,
    this.maxUnderScrollExtent,
    this.headerTriggerDistance = 80.0,
    this.footerTriggerDistance = 15.0,
    this.hideFooterWhenNotFull = false,
    this.enableRefreshVibrate = false,
    this.enableLoadMoreVibrate = false,
    this.topHitBoundary,
    this.bottomHitBoundary,
  })  : assert(headerTriggerDistance > 0),
        assert(twiceTriggerDistance > 0),
        assert(closeTwoLevelDistance > 0),
        assert(dragSpeedRatio > 0),
        super(key: key, child: child);

  /// Constructs a RefreshConfiguration by copying attributes from ancestor nodes.
  ///
  /// Useful when a specific subtree needs a slightly different configuration.
  RefreshConfiguration.copyAncestor({
    Key? key,
    required BuildContext context,
    required Widget child,
    IndicatorBuilder? headerBuilder,
    IndicatorBuilder? footerBuilder,
    double? dragSpeedRatio,
    ShouldFollowContent? shouldFooterFollowWhenNotFull,
    bool? enableScrollWhenTwoLevel,
    bool? enableBallisticRefresh,
    bool? enableBallisticLoad,
    bool? enableLoadingWhenNoData,
    SpringDescription? springDescription,
    bool? enableScrollWhenRefreshCompleted,
    bool? enableLoadingWhenFailed,
    double? twiceTriggerDistance,
    double? closeTwoLevelDistance,
    bool? skipCanRefresh,
    double? maxOverScrollExtent,
    double? maxUnderScrollExtent,
    double? topHitBoundary,
    double? bottomHitBoundary,
    double? headerTriggerDistance,
    double? footerTriggerDistance,
    bool? enableRefreshVibrate,
    bool? enableLoadMoreVibrate,
    bool? hideFooterWhenNotFull,
  })  : assert(
  RefreshConfiguration.of(context) != null,
  "No ancestor RefreshConfiguration found. Please ensure that RefreshConfiguration is an ancestor of this widget.",
  ),
        headerBuilder =
            headerBuilder ?? RefreshConfiguration.of(context)!.headerBuilder,
        footerBuilder =
            footerBuilder ?? RefreshConfiguration.of(context)!.footerBuilder,
        dragSpeedRatio =
            dragSpeedRatio ?? RefreshConfiguration.of(context)!.dragSpeedRatio,
        twiceTriggerDistance = twiceTriggerDistance ??
            RefreshConfiguration.of(context)!.twiceTriggerDistance,
        headerTriggerDistance = headerTriggerDistance ??
            RefreshConfiguration.of(context)!.headerTriggerDistance,
        footerTriggerDistance = footerTriggerDistance ??
            RefreshConfiguration.of(context)!.footerTriggerDistance,
        springDescription = springDescription ??
            RefreshConfiguration.of(context)!.springDescription,
        hideFooterWhenNotFull = hideFooterWhenNotFull ??
            RefreshConfiguration.of(context)!.hideFooterWhenNotFull,
        maxOverScrollExtent = maxOverScrollExtent ??
            RefreshConfiguration.of(context)!.maxOverScrollExtent,
        maxUnderScrollExtent = maxUnderScrollExtent ??
            RefreshConfiguration.of(context)!.maxUnderScrollExtent,
        topHitBoundary = topHitBoundary ??
            RefreshConfiguration.of(context)!.topHitBoundary,
        bottomHitBoundary = bottomHitBoundary ??
            RefreshConfiguration.of(context)!.bottomHitBoundary,
        skipCanRefresh =
            skipCanRefresh ?? RefreshConfiguration.of(context)!.skipCanRefresh,
        enableScrollWhenRefreshCompleted = enableScrollWhenRefreshCompleted ??
            RefreshConfiguration.of(context)!.enableScrollWhenRefreshCompleted,
        enableScrollWhenTwoLevel = enableScrollWhenTwoLevel ??
            RefreshConfiguration.of(context)!.enableScrollWhenTwoLevel,
        enableBallisticRefresh = enableBallisticRefresh ??
            RefreshConfiguration.of(context)!.enableBallisticRefresh,
        enableBallisticLoad = enableBallisticLoad ??
            RefreshConfiguration.of(context)!.enableBallisticLoad,
        enableLoadingWhenNoData = enableLoadingWhenNoData ??
            RefreshConfiguration.of(context)!.enableLoadingWhenNoData,
        enableLoadingWhenFailed = enableLoadingWhenFailed ??
            RefreshConfiguration.of(context)!.enableLoadingWhenFailed,
        closeTwoLevelDistance = closeTwoLevelDistance ??
            RefreshConfiguration.of(context)!.closeTwoLevelDistance,
        enableRefreshVibrate = enableRefreshVibrate ??
            RefreshConfiguration.of(context)!.enableRefreshVibrate,
        enableLoadMoreVibrate = enableLoadMoreVibrate ??
            RefreshConfiguration.of(context)!.enableLoadMoreVibrate,
        shouldFooterFollowWhenNotFull = shouldFooterFollowWhenNotFull ??
            RefreshConfiguration.of(context)!.shouldFooterFollowWhenNotFull,
        super(key: key, child: child);

  static RefreshConfiguration? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RefreshConfiguration>();
  }

  @override
  bool updateShouldNotify(covariant RefreshConfiguration oldWidget) {
    return skipCanRefresh != oldWidget.skipCanRefresh ||
        hideFooterWhenNotFull != oldWidget.hideFooterWhenNotFull ||
        dragSpeedRatio != oldWidget.dragSpeedRatio ||
        enableScrollWhenRefreshCompleted !=
            oldWidget.enableScrollWhenRefreshCompleted ||
        enableBallisticRefresh != oldWidget.enableBallisticRefresh ||
        enableScrollWhenTwoLevel != oldWidget.enableScrollWhenTwoLevel ||
        closeTwoLevelDistance != oldWidget.closeTwoLevelDistance ||
        footerTriggerDistance != oldWidget.footerTriggerDistance ||
        headerTriggerDistance != oldWidget.headerTriggerDistance ||
        twiceTriggerDistance != oldWidget.twiceTriggerDistance ||
        maxUnderScrollExtent != oldWidget.maxUnderScrollExtent ||
        oldWidget.maxOverScrollExtent != maxOverScrollExtent ||
        enableLoadingWhenFailed != oldWidget.enableLoadingWhenFailed ||
        topHitBoundary != oldWidget.topHitBoundary ||
        enableRefreshVibrate != oldWidget.enableRefreshVibrate ||
        enableLoadMoreVibrate != oldWidget.enableLoadMoreVibrate ||
        bottomHitBoundary != oldWidget.bottomHitBoundary;
  }
}
