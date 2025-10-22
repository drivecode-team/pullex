/*
    Based on original work by Jpeng (peng8350@gmail.com)
    Original repository: https://github.com/xxzj990-game/flutter_pulltorefresh

    Modified and maintained by Drivecode Team
    Modifications include bug fixes, refactoring, enhancements
    This file is part of the pullex package.
 */

import 'package:pullex/pullex.dart';
import 'package:flutter/widgets.dart';
import 'package:pullex/src/internal/indicator_wrap.dart';

/// Proxy for linking an external header indicator placed outside the scroll view.
///
/// Use this when you want to put your header outside the scroll area (for example inside an AppBar)
/// but still want it to behave as a refresh header.
///
/// Example:
/// ```dart
/// final GlobalKey<MyCustomHeaderState> headerKey = GlobalKey();
///
/// Column(
///   children: [
///     MyCustomHeader(key: headerKey),
///     Expanded(
///       child: PullexRefresh(
///         controller: controller,
///         header: HeaderLinkProxy(linkKey: headerKey),
///         onRefresh: onRefresh,
///         child: ListView(...),
///       ),
///     ),
///   ],
/// );
/// ```
class HeaderLinkProxy extends RefreshIndicator {
  /// The GlobalKey of the external header widget that implements RefreshProcessor.
  final Key linkKey;

  const HeaderLinkProxy({
    Key? key,
    required this.linkKey,
    double height = 0.0,
    RefreshStyle? refreshStyle,
    Duration completeDuration = const Duration(milliseconds: 200),
  }) : super(
    height: height,
    refreshStyle: refreshStyle,
    completeDuration: completeDuration,
    key: key,
  );

  @override
  State<StatefulWidget> createState() => _HeaderLinkProxyState();
}

class _HeaderLinkProxyState extends RefreshIndicatorState<HeaderLinkProxy> {
  @override
  void resetValue() {
    ((widget.linkKey as GlobalKey).currentState as RefreshProcessor).resetValue();
  }

  @override
  Future<void> endRefresh() {
    return ((widget.linkKey as GlobalKey).currentState as RefreshProcessor)
        .endRefresh();
  }

  @override
  void onModeChange(RefreshStatus? mode) {
    ((widget.linkKey as GlobalKey).currentState as RefreshProcessor)
        .onModeChange(mode);
  }

  @override
  void onOffsetChange(double offset) {
    ((widget.linkKey as GlobalKey).currentState as RefreshProcessor)
        .onOffsetChange(offset);
  }

  @override
  Future<void> readyToRefresh() {
    return ((widget.linkKey as GlobalKey).currentState as RefreshProcessor)
        .readyToRefresh();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    return const SizedBox.shrink();
  }
}
