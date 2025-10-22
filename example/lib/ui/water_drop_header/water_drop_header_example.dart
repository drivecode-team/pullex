import 'package:flutter/material.dart';
import 'package:pullex/pullex.dart';

class WaterDropHeaderExample extends StatefulWidget {
  const WaterDropHeaderExample({super.key});

  @override
  State<WaterDropHeaderExample> createState() => _WaterDropHeaderExampleState();
}

class _WaterDropHeaderExampleState extends State<WaterDropHeaderExample> {
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  List<int> items = List.generate(20, (index) => index);

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    setState(() {
      items = List.generate(20, (index) => index);
    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    setState(() {
      items.addAll(List.generate(10, (index) => items.length + index));
    });
    _refreshController.loadComplete();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WaterDropHeader Example')),
      body: PullexRefresh(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(
          waterDropColor: Colors.blueAccent,
          idleIcon: Icon(
            Icons.refresh,
            color: Colors.white,
            size: 20,
          ),
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
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