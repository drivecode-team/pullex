import 'package:flutter/material.dart';
import 'package:pullex/pullex.dart';

class BaseHeaderExample extends StatefulWidget {
  const BaseHeaderExample({super.key});

  @override
  State<BaseHeaderExample> createState() =>
      _BaseHeaderExampleState();
}

class _BaseHeaderExampleState extends State<BaseHeaderExample> {
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  List<int> items = List.generate(20, (index) => index);

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 3000));

    if (!mounted) return;

    setState(() {
      items = List.generate(20, (index) => index);
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Base Indicator Example')),
      body: PullexRefresh(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
        header: BaseHeader(),
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemBuilder: (c, i) => ListTile(
            title: Text('Item ${items[i]}'),
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