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

/// Proxy for linking an external footer indicator placed outside the scroll view.
///
/// Use this when you want to put your footer outside the scroll area (for example below a fixed button)
/// but still want it to behave as a load more footer.
///
/// Example:
/// ```dart
/// final GlobalKey<MyCustomFooterState> footerKey = GlobalKey();
///
/// Column(
///   children: [
///     Expanded(
///       child: PullexRefresh(
///         controller: controller,
///         footer: FooterLinkProxy(linkKey: footerKey),
///         onLoading: onLoading,
///         child: ListView(...),
///       ),
///     ),
///     MyCustomFooter(key: footerKey),
///   ],
/// );
/// ```
class FooterLinkProxy extends LoadIndicator {
  /// The GlobalKey of the external footer widget that implements LoadingProcessor.
  final Key linkKey;

  const FooterLinkProxy({
    Key? key,
    required this.linkKey,
    double height = 0.0,
    LoadStyle loadStyle = LoadStyle.showAlways,
  }) : super(
    height: height,
    loadStyle: loadStyle,
    key: key,
  );

  @override
  State<StatefulWidget> createState() => _FooterLinkProxyState();
}

class _FooterLinkProxyState extends LoadIndicatorState<FooterLinkProxy> {
  @override
  void onModeChange(LoadStatus? mode) {
    ((widget.linkKey as GlobalKey).currentState as LoadingProcessor)
        .onModeChange(mode);
  }

  @override
  void onOffsetChange(double offset) {
    ((widget.linkKey as GlobalKey).currentState as LoadingProcessor)
        .onOffsetChange(offset);
  }

  @override
  Widget buildContent(BuildContext context, LoadStatus? mode) {
    return const SizedBox.shrink();
  }
}
