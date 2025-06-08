/*
    Based on original work by Jpeng (peng8350@gmail.com)
    Original repository: https://github.com/xxzj990-game/flutter_pulltorefresh

    Modified and maintained by Drivecode Team
    Modifications include bug fixes, refactoring, enhancements
    This file is part of the pullex package.
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:pullex/pullex.dart';
import 'package:pullex/src/internal/indicator_wrap.dart';
import 'package:pullex/src/internal/refresh_physics.dart';
import 'package:pullex/src/internal/slivers.dart';

// ignore_for_file: INVALID_USE_OF_PROTECTED_MEMBER
// ignore_for_file: INVALID_USE_OF_VISIBLE_FOR_TESTING_MEMBER
// ignore_for_file: DEPRECATED_MEMBER_USE

/// Callback for two-level open/close state changes.
typedef void OnTwoLevel(bool isOpen);

/// Determines whether footer should follow content based on load status.
typedef bool ShouldFollowContent(LoadStatus? status);

/// Global default indicator builder.
typedef IndicatorBuilder = Widget Function();

/// Builder for attaching refresh behavior with custom scroll physics.
typedef Widget RefresherBuilder(BuildContext context, RefreshPhysics physics);

/// Status of the header indicator.
enum RefreshStatus {
  idle,
  canRefresh,
  refreshing,
  completed,
  failed,
  canTwoLevel,
  twoLevelOpening,
  twoLeveling,
  twoLevelClosing
}

/// Status of the footer indicator.
enum LoadStatus {
  idle,
  canLoading,
  loading,
  noMore,
  failed
}

/// Display style of the header indicator.
enum RefreshStyle {
  Follow,
  UnFollow,
  Behind,
  Front
}

/// Display style of the footer indicator.
enum LoadStyle {
  ShowAlways,
  HideAlways,
  ShowWhenLoading
}

/// Main component providing pull-to-refresh and load-more functionality.
///
/// The [PullexRefreshController] manages header and footer state.
/// Supports both pull-down refresh and pull-up load.
///
/// Header examples: [BaseHeader], [WaterDropMaterialHeader], [MaterialHeader], [WaterDropHeader], [BezierCircleHeader].
/// Footer example: [BaseFooter].
/// For custom headers or footers, use [CustomHeader] or [CustomFooter].
///
/// See also:
/// * [RefreshConfiguration] — global configuration for PullexRefresh widgets.
/// * [PullexRefreshController] — controller for managing header and footer state.
class PullexRefresh extends StatefulWidget {
  /// Content widget. If child is a [ScrollView], internal slivers will be used.
  /// If not, content will be wrapped in [SliverToBoxAdapter].
  final Widget? child;

  /// Header indicator widget displayed before content (top, bottom, left or right depending on scroll direction).
  final Widget? header;

  /// Footer indicator widget displayed after content (bottom, top, left or right depending on scroll direction).
  final Widget? footer;

  /// Enables pull-up to load more.
  final bool enablePullUp;

  /// Enables second-level pull interaction.
  final bool enableTwoLevel;

  /// Enables pull-down to refresh.
  final bool enablePullDown;

  /// Called when header triggers refresh.
  final VoidCallback? onRefresh;

  /// Called when footer triggers load more.
  final VoidCallback? onLoading;

  /// Called when header triggers two-level interaction.
  final OnTwoLevel? onTwoLevel;

  /// Controller managing inner state.
  final PullexRefreshController controller;

  /// Builder for advanced use cases requiring full control of slivers.
  final RefresherBuilder? builder;

  /// ScrollView configuration for non-ScrollView child.
  final Axis? scrollDirection;
  final bool? reverse;
  final ScrollController? scrollController;
  final bool? primary;
  final ScrollPhysics? physics;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior? dragStartBehavior;

  /// Creates a PullexRefresh widget for common use cases.
  PullexRefresh({
    Key? key,
    required this.controller,
    this.child,
    this.header,
    this.footer,
    this.enablePullDown = true,
    this.enablePullUp = false,
    this.enableTwoLevel = false,
    this.onRefresh,
    this.onLoading,
    this.onTwoLevel,
    this.dragStartBehavior,
    this.primary,
    this.cacheExtent,
    this.semanticChildCount,
    this.reverse,
    this.physics,
    this.scrollDirection,
    this.scrollController,
  })  : builder = null,
        super(key: key);

  /// Creates a PullexRefresh widget using a custom builder.
  /// Useful when integrating with advanced widgets like NestedScrollView.
  PullexRefresh.builder({
    Key? key,
    required this.controller,
    required this.builder,
    this.enablePullDown = true,
    this.enablePullUp = false,
    this.enableTwoLevel = false,
    this.onRefresh,
    this.onLoading,
    this.onTwoLevel,
  })  : header = null,
        footer = null,
        child = null,
        scrollController = null,
        scrollDirection = null,
        physics = null,
        reverse = null,
        semanticChildCount = null,
        dragStartBehavior = null,
        cacheExtent = null,
        primary = null,
        super(key: key);

  /// Finds the nearest ancestor [PullexRefresh] widget.
  static PullexRefresh? of(BuildContext? context) {
    return context!.findAncestorWidgetOfExactType<PullexRefresh>();
  }

  /// Finds the nearest ancestor [PullexRefreshState].
  static PullexRefreshState? ofState(BuildContext? context) {
    return context!.findAncestorStateOfType<PullexRefreshState>();
  }

  @override
  State<StatefulWidget> createState() => PullexRefreshState();
}

class PullexRefreshState extends State<PullexRefresh> {
  RefreshPhysics? _physics;
  bool _updatePhysics = false;
  double viewportExtent = 0;
  bool _canDrag = true;

  final RefreshIndicator defaultHeader =
      defaultTargetPlatform == TargetPlatform.iOS
          ? BaseHeader()
          : MaterialHeader();

  final LoadIndicator defaultFooter = BaseFooter();

  //build slivers from child Widget
  List<Widget>? _buildSliversByChild(BuildContext context, Widget? child,
      RefreshConfiguration? configuration) {
    List<Widget>? slivers;
    if (child is ScrollView) {
      if (child is BoxScrollView) {
        //avoid system inject padding when own indicator top or bottom
        Widget sliver = child.buildChildLayout(context);
        if (child.padding != null) {
          slivers = [SliverPadding(sliver: sliver, padding: child.padding!)];
        } else {
          slivers = [sliver];
        }
      } else {
        slivers = List.from(child.buildSlivers(context), growable: true);
      }
    } else if (child is! Scrollable) {
      slivers = [
        SliverRefreshBody(
          child: child ?? Container(),
        )
      ];
    }
    if (widget.enablePullDown || widget.enableTwoLevel) {
      slivers?.insert(
          0,
          widget.header ??
              (configuration?.headerBuilder != null
                  ? configuration?.headerBuilder!()
                  : null) ??
              defaultHeader);
    }
    //insert header or footer
    if (widget.enablePullUp) {
      slivers?.add(widget.footer ??
          (configuration?.footerBuilder != null
              ? configuration?.footerBuilder!()
              : null) ??
          defaultFooter);
    }

    return slivers;
  }

  ScrollPhysics _getScrollPhysics(
      RefreshConfiguration? conf, ScrollPhysics physics) {
    final bool isBouncingPhysics = physics is BouncingScrollPhysics ||
        (physics is AlwaysScrollableScrollPhysics &&
            ScrollConfiguration.of(context)
                    .getScrollPhysics(context)
                    .runtimeType ==
                BouncingScrollPhysics);
    return _physics = RefreshPhysics(
            dragSpeedRatio: conf?.dragSpeedRatio ?? 1,
            springDescription: conf?.springDescription ??
                const SpringDescription(
                  mass: 2.2,
                  stiffness: 150,
                  damping: 16,
                ),
            controller: widget.controller,
            enableScrollWhenTwoLevel: conf?.enableScrollWhenTwoLevel ?? true,
            updateFlag: _updatePhysics ? 0 : 1,
            enableScrollWhenRefreshCompleted:
                conf?.enableScrollWhenRefreshCompleted ?? false,
            maxUnderScrollExtent: conf?.maxUnderScrollExtent ??
                (isBouncingPhysics ? double.infinity : 0.0),
            maxOverScrollExtent: conf?.maxOverScrollExtent ??
                (isBouncingPhysics ? double.infinity : 60.0),
            topHitBoundary: conf?.topHitBoundary ??
                (isBouncingPhysics ? double.infinity : 0.0),
            // need to fix default value by ios or android later
            bottomHitBoundary: conf?.bottomHitBoundary ??
                (isBouncingPhysics ? double.infinity : 0.0))
        .applyTo(!_canDrag ? NeverScrollableScrollPhysics() : physics);
  }

  // build the customScrollView
  Widget? _buildBodyBySlivers(
      Widget? childView, List<Widget>? slivers, RefreshConfiguration? conf) {
    Widget? body;
    if (childView is! Scrollable) {
      bool? primary = widget.primary;
      Key? key;
      double? cacheExtent = widget.cacheExtent;

      Axis? scrollDirection = widget.scrollDirection;
      int? semanticChildCount = widget.semanticChildCount;
      bool? reverse = widget.reverse;
      ScrollController? scrollController = widget.scrollController;
      DragStartBehavior? dragStartBehavior = widget.dragStartBehavior;
      ScrollPhysics? physics = widget.physics;
      Key? center;
      double? anchor;
      ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;
      String? restorationId;
      Clip? clipBehavior;

      if (childView is ScrollView) {
        primary = primary ?? childView.primary;
        cacheExtent = cacheExtent ?? childView.cacheExtent;
        key = key ?? childView.key;
        semanticChildCount = semanticChildCount ?? childView.semanticChildCount;
        reverse = reverse ?? childView.reverse;
        dragStartBehavior = dragStartBehavior ?? childView.dragStartBehavior;
        scrollDirection = scrollDirection ?? childView.scrollDirection;
        physics = physics ?? childView.physics;
        center = center ?? childView.center;
        anchor = anchor ?? childView.anchor;
        keyboardDismissBehavior =
            keyboardDismissBehavior ?? childView.keyboardDismissBehavior;
        restorationId = restorationId ?? childView.restorationId;
        clipBehavior = clipBehavior ?? childView.clipBehavior;
        scrollController = scrollController ?? childView.controller;
      }
      body = CustomScrollView(
        // ignore: DEPRECATED_MEMBER_USE_FROM_SAME_PACKAGE
        controller: scrollController,
        cacheExtent: cacheExtent,
        key: key,
        scrollDirection: scrollDirection ?? Axis.vertical,
        semanticChildCount: semanticChildCount,
        primary: primary,
        clipBehavior: clipBehavior ?? Clip.hardEdge,
        keyboardDismissBehavior:
            keyboardDismissBehavior ?? ScrollViewKeyboardDismissBehavior.manual,
        anchor: anchor ?? 0.0,
        restorationId: restorationId,
        center: center,
        physics:
            _getScrollPhysics(conf, physics ?? AlwaysScrollableScrollPhysics()),
        slivers: slivers!,
        dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
        reverse: reverse ?? false,
      );
    } else
      body = Scrollable(
        physics: _getScrollPhysics(
            conf, childView.physics ?? AlwaysScrollableScrollPhysics()),
        controller: childView.controller,
        axisDirection: childView.axisDirection,
        semanticChildCount: childView.semanticChildCount,
        dragStartBehavior: childView.dragStartBehavior,
        viewportBuilder: (context, offset) {
          Viewport viewport =
              childView.viewportBuilder(context, offset) as Viewport;
          if (widget.enablePullDown) {
            viewport.children.insert(
                0,
                widget.header ??
                    (conf?.headerBuilder != null
                        ? conf?.headerBuilder!()
                        : null) ??
                    defaultHeader);
          }
          //insert header or footer
          if (widget.enablePullUp) {
            viewport.children.add(widget.footer ??
                (conf?.footerBuilder != null ? conf?.footerBuilder!() : null) ??
                defaultFooter);
          }
          return viewport;
        },
      );

    return body;
  }

  bool _ifNeedUpdatePhysics() {
    RefreshConfiguration? conf = RefreshConfiguration.of(context);
    if (conf == null || _physics == null) {
      return false;
    }

    if (conf.topHitBoundary != _physics!.topHitBoundary ||
        _physics!.bottomHitBoundary != conf.bottomHitBoundary ||
        conf.maxOverScrollExtent != _physics!.maxOverScrollExtent ||
        _physics!.maxUnderScrollExtent != conf.maxUnderScrollExtent ||
        _physics!.dragSpeedRatio != conf.dragSpeedRatio ||
        _physics!.enableScrollWhenTwoLevel != conf.enableScrollWhenTwoLevel ||
        _physics!.enableScrollWhenRefreshCompleted !=
            conf.enableScrollWhenRefreshCompleted) {
      return true;
    }
    return false;
  }

  void setCanDrag(bool canDrag) {
    if (_canDrag == canDrag) {
      return;
    }
    setState(() {
      _canDrag = canDrag;
    });
  }

  @override
  void didUpdateWidget(PullexRefresh oldWidget) {
    // TODO: implement didUpdateWidget
    if (widget.controller != oldWidget.controller) {
      widget.controller.headerMode!.value =
          oldWidget.controller.headerMode!.value;
      widget.controller.footerMode!.value =
          oldWidget.controller.footerMode!.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_ifNeedUpdatePhysics()) {
      _updatePhysics = !_updatePhysics;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.controller.initialRefresh) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //  if mounted,it avoid one situation: when init done,then dispose the widget before build.
        //  this   situation mostly TabBarView
        if (mounted) widget.controller.requestRefresh();
      });
    }
    widget.controller.bindState(this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.controller.detachPosition();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RefreshConfiguration? configuration =
        RefreshConfiguration.of(context);
    Widget? body;
    if (widget.builder != null)
      body = widget.builder!(
          context,
          _getScrollPhysics(configuration, AlwaysScrollableScrollPhysics())
              as RefreshPhysics);
    else {
      List<Widget>? slivers =
          _buildSliversByChild(context, widget.child, configuration);
      body = _buildBodyBySlivers(widget.child, slivers, configuration);
    }
    if (configuration == null) {
      body = RefreshConfiguration(child: body!);
    }
    return LayoutBuilder(
      builder: (c2, cons) {
        viewportExtent = cons.biggest.height;
        return body!;
      },
    );
  }
}
