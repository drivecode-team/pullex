import 'package:flutter/material.dart';
import 'package:pullex/pullex.dart';

class LoadMoreBaseHeaderExample extends StatefulWidget {
  const LoadMoreBaseHeaderExample({super.key});

  @override
  State<LoadMoreBaseHeaderExample> createState() =>
      _LoadMoreBaseHeaderExampleState();
}

class _LoadMoreBaseHeaderExampleState
    extends State<LoadMoreBaseHeaderExample> {
  final PullexRefreshController _controller = PullexRefreshController();

  List<int> items = List.generate(20, (index) => index);
  bool noMoreData = false;

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    setState(() {
      items = List.generate(20, (index) => index);
      noMoreData = false; // Скидаємо "немає більше даних" при refresh
    });
    _controller.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    if (items.length >= 50) {
      setState(() {
        noMoreData = true;
      });
      _controller.loadNoData();
      return;
    }

    setState(() {
      final nextIndex = items.length;
      items.addAll(List.generate(10, (index) => nextIndex + index));
    });
    _controller.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Load More Base Indicator Example')),
      body: PullexRefresh(
        controller: _controller,
        enablePullDown: true,
        enablePullUp: true,
        header: const BaseHeader(),
        footer: const BaseFooter(),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemBuilder: (context, index) =>
              ListTile(title: Text('Item $index')),
          itemCount: items.length,
        ),
      ),
    );
  }
}
