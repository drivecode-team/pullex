import 'package:flutter/material.dart';
import 'package:pullex/pullex.dart';

class CustomHeaderExample extends StatefulWidget {
  const CustomHeaderExample({super.key});

  @override
  State<CustomHeaderExample> createState() => _CustomHeaderExampleState();
}

class _CustomHeaderExampleState extends State<CustomHeaderExample> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<int> items = List.generate(20, (index) => index);

  double _currentOffset = 0.0;
  RefreshStatus? _currentStatus;

  void _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      items = List.generate(20, (index) => index);
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Header Example')),
      body: PullexRefresh(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
        header: CustomHeader(
          height: 80.0,
          onOffsetChange: (offset) {
            setState(() {
              _currentOffset = offset;
            });
          },
          onModeChange: (mode) {
            setState(() {
              _currentStatus = mode;
            });
          },
          builder: (context, mode) {
            Widget content;

            switch (mode) {
              case RefreshStatus.idle:
                content = const Text("Pull down to refresh");
                break;
              case RefreshStatus.canRefresh:
                content = const Text("Release to refresh");
                break;
              case RefreshStatus.refreshing:
                content = const CircularProgressIndicator(strokeWidth: 2);
                break;
              case RefreshStatus.completed:
                content = const Text("Refresh completed!");
                break;
              case RefreshStatus.failed:
                content = const Text("Refresh failed");
                break;
              default:
                content = const SizedBox();
            }

            return Container(
              height: 80.0,
              color: Colors.blueAccent.withValues(alpha: 0.2),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    content,
                    const SizedBox(height: 4),
                    Text("Offset: ${_currentOffset.toStringAsFixed(1)} px",
                        style: TextStyle(fontSize: 12)),
                    Text(
                        "Status: ${_currentStatus?.toString().split('.').last ?? 'unknown'}",
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            );
          },
        ),
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemBuilder: (context, index) => ListTile(
            title: Text('Item ${items[index]}'),
          ),
          itemCount: items.length,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
