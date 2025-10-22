import 'package:flutter/material.dart';
import 'package:pullex/pullex.dart';

class StretchHeaderExample extends StatefulWidget {
  const StretchHeaderExample({super.key});

  @override
  State<StretchHeaderExample> createState() =>
      _StretchHeaderExampleState();
}

class _StretchHeaderExampleState extends State<StretchHeaderExample> {
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  StretchDismissType _dismissType = StretchDismissType.rectSpread;
  StretchCircleType _circleType = StretchCircleType.progress;

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
      appBar: AppBar(title: const Text('Stretch Circle Header Example')),
      body: PullexRefresh(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
        header: StretchCircleHeader(
          stretchColor: Colors.blueAccent,
          circleColor: Colors.white,
          circleRadius: 16,
          dismissType: _dismissType,
          circleType: _circleType,
        ),
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Dismiss Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...StretchDismissType.values.map((type) {
              return RadioListTile<StretchDismissType>(
                title: Text(type.toString().split('.').last),
                value: type,
                groupValue: _dismissType,
                onChanged: (value) {
                  setState(() {
                    _dismissType = value!;
                  });
                },
              );
            }),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Circle Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...StretchCircleType.values.map((type) {
              return RadioListTile<StretchCircleType>(
                title: Text(type.toString().split('.').last),
                value: type,
                groupValue: _circleType,
                onChanged: (value) {
                  setState(() {
                    _circleType = value!;
                  });
                },
              );
            }),
            Divider(),
            ...items.map((index) {
              return ListTile(
                title: Text('Item $index'),
              );
            }),
          ],
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
