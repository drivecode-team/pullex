/*
    Based on original work by Jpeng (peng8350@gmail.com)
    Original repository: https://github.com/xxzj990-game/flutter_pulltorefresh

    Modified and maintained by Drivecode Team
    Modifications include bug fixes, refactoring, enhancements
    This file is part of the pullex package.
 */

import 'package:flutter/widgets.dart';
import 'package:pullex/pullex.dart';
import 'package:pullex/src/internal/indicator_wrap.dart';

// ignore_for_file: INVALID_USE_OF_PROTECTED_MEMBER
// ignore_for_file: INVALID_USE_OF_VISIBLE_FOR_TESTING_MEMBER
// ignore_for_file: DEPRECATED_MEMBER_USE

/// Controller for managing header and footer state.
/// Provides methods to trigger refresh, loading and two-level interactions.
///
/// See also:
/// * [PullexRefresh] — a widget to easily integrate pull-to-refresh and load-more functionality.
class RefreshController {
  PullexRefreshState? _refresherState;

  RefreshNotifier<RefreshStatus>? headerMode;
  RefreshNotifier<LoadStatus>? footerMode;

  ScrollPosition? position;

  RefreshStatus? get headerStatus => headerMode?.value;
  LoadStatus? get footerStatus => footerMode?.value;

  bool get isRefresh => headerMode?.value == RefreshStatus.refreshing;

  bool get isTwoLevel =>
      headerMode?.value == RefreshStatus.twoLeveling ||
      headerMode?.value == RefreshStatus.twoLevelOpening ||
      headerMode?.value == RefreshStatus.twoLevelClosing;

  bool get isLoading => footerMode?.value == LoadStatus.loading;

  final bool initialRefresh;

  RefreshController({
    this.initialRefresh = false,
    RefreshStatus? initialRefreshStatus,
    LoadStatus? initialLoadStatus,
  }) {
    headerMode = RefreshNotifier(initialRefreshStatus ?? RefreshStatus.idle);
    footerMode = RefreshNotifier(initialLoadStatus ?? LoadStatus.idle);
  }

  void bindState(PullexRefreshState state) {
    assert(
      _refresherState == null,
      "Don't use one PullexRefreshController with multiple PullexRefresh widgets. It may cause unexpected bugs, especially in TabBarView.",
    );
    _refresherState = state;
  }

  void onPositionUpdated(ScrollPosition newPosition) {
    position?.isScrollingNotifier.removeListener(_listenScrollEnd);
    position = newPosition;
    position!.isScrollingNotifier.addListener(_listenScrollEnd);
  }

  void detachPosition() {
    _refresherState = null;
    position?.isScrollingNotifier.removeListener(_listenScrollEnd);
  }

  StatefulElement? _findIndicator(BuildContext context, Type elementType) {
    StatefulElement? result;
    context.visitChildElements((Element e) {
      if (elementType == RefreshIndicator && e.widget is RefreshIndicator) {
        result = e as StatefulElement?;
      } else if (elementType == LoadIndicator && e.widget is LoadIndicator) {
        result = e as StatefulElement?;
      }
      result ??= _findIndicator(e, elementType);
    });
    return result;
  }

  void _listenScrollEnd() {
    if (position != null && position!.outOfRange) {
      position?.activity?.applyNewDimensions();
    }
  }

  Future<void>? requestRefresh({
    bool needMove = true,
    bool needCallback = true,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.linear,
  }) {
    assert(position != null,
        'requestRefresh() should be called after UI is rendered.');
    if (isRefresh) return Future.value();

    final indicatorElement =
        _findIndicator(position!.context.storageContext, RefreshIndicator);
    if (indicatorElement == null || _refresherState == null) return null;

    (indicatorElement.state as RefreshIndicatorState).floating = true;

    if (needMove && _refresherState!.mounted) {
      _refresherState!.setCanDrag(false);
    }

    if (needMove) {
      return Future.delayed(const Duration(milliseconds: 50)).then((_) async {
        await position
            ?.animateTo(position!.minScrollExtent - 0.0001,
                duration: duration, curve: curve)
            .then((_) {
          if (_refresherState != null && _refresherState!.mounted) {
            _refresherState!.setCanDrag(true);
            if (needCallback) {
              headerMode!.value = RefreshStatus.refreshing;
            } else {
              headerMode!.setValueWithNoNotify(RefreshStatus.refreshing);
              if (indicatorElement.state.mounted) {
                (indicatorElement.state as RefreshIndicatorState)
                    .setState(() {});
              }
            }
          }
        });
      });
    } else {
      return Future.value().then((_) {
        headerMode!.value = RefreshStatus.refreshing;
      });
    }
  }

  Future<void> requestTwoLevel({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) {
    assert(position != null,
        'requestTwoLevel() should be called after UI is rendered.');
    headerMode!.value = RefreshStatus.twoLevelOpening;
    return Future.delayed(const Duration(milliseconds: 50)).then((_) async {
      await position?.animateTo(position!.minScrollExtent,
          duration: duration, curve: curve);
    });
  }

  Future<void>? requestLoading({
    bool needMove = true,
    bool needCallback = true,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) {
    assert(position != null,
        'requestLoading() should be called after UI is rendered.');
    if (isLoading) return Future.value();

    final indicatorElement =
        _findIndicator(position!.context.storageContext, LoadIndicator);
    if (indicatorElement == null || _refresherState == null) return null;

    (indicatorElement.state as LoadIndicatorState).floating = true;

    if (needMove && _refresherState!.mounted) {
      _refresherState!.setCanDrag(false);
    }

    if (needMove) {
      return Future.delayed(const Duration(milliseconds: 50)).then((_) async {
        await position
            ?.animateTo(position!.maxScrollExtent,
                duration: duration, curve: curve)
            .then((_) {
          if (_refresherState != null && _refresherState!.mounted) {
            _refresherState!.setCanDrag(true);
            if (needCallback) {
              footerMode!.value = LoadStatus.loading;
            } else {
              footerMode!.setValueWithNoNotify(LoadStatus.loading);
              if (indicatorElement.state.mounted) {
                (indicatorElement.state as LoadIndicatorState).setState(() {});
              }
            }
          }
        });
      });
    } else {
      return Future.value().then((_) {
        footerMode!.value = LoadStatus.loading;
      });
    }
  }

  void refreshCompleted({bool resetFooterState = false}) {
    headerMode?.value = RefreshStatus.completed;
    if (resetFooterState) {
      resetNoData();
    }
  }

  Future<void>? twoLevelComplete({
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.linear,
  }) {
    headerMode?.value = RefreshStatus.twoLevelClosing;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      position!
          .animateTo(0.0, duration: duration, curve: curve)
          .whenComplete(() {
        headerMode!.value = RefreshStatus.idle;
      });
    });
    return null;
  }

  void refreshFailed() {
    headerMode?.value = RefreshStatus.failed;
  }

  void refreshToIdle() {
    headerMode?.value = RefreshStatus.idle;
  }

  void loadComplete() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      footerMode?.value = LoadStatus.idle;
    });
  }

  void loadFailed() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      footerMode?.value = LoadStatus.failed;
    });
  }

  void loadNoData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      footerMode?.value = LoadStatus.noMore;
    });
  }

  void resetNoData() {
    if (footerMode?.value == LoadStatus.noMore) {
      footerMode!.value = LoadStatus.idle;
    }
  }

  void dispose() {
    headerMode?.dispose();
    footerMode?.dispose();
    headerMode = null;
    footerMode = null;
  }
}
