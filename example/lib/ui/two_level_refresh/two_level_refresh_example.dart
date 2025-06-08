import 'package:flutter/material.dart';
import 'package:pullex/pullex.dart';


class TwoLevelRefreshExample extends StatefulWidget {
  const TwoLevelRefreshExample({super.key});

  @override
  State<TwoLevelRefreshExample> createState() => _TwoLevelRefreshExampleState();
}

class _TwoLevelRefreshExampleState extends State<TwoLevelRefreshExample> {
  final PullexRefreshController _controller = PullexRefreshController();

  List<int> items = List.generate(20, (index) => index);
  bool _isTwoLevelOpened = false;

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    setState(() {
      items = List.generate(20, (index) => index);
    });
    _controller.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    setState(() {
      final nextIndex = items.length;
      items.addAll(List.generate(10, (index) => nextIndex + index));
    });
    _controller.loadComplete();
  }

  Widget _buildTwoLevelView() {
    return Container(
      color: Colors.deepOrangeAccent,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView( // <=== ось цей FIX
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Second Level View 🚀',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _controller.twoLevelComplete();
                  },
                  child: const Text('Назад до списку'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TwoLevel Refresh Example')),
      body: PullexRefresh(
        controller: _controller,
        enablePullDown: true,
        enablePullUp: true,
        enableTwoLevel: true,
        header: TwoLevelHeader(
          displayAlignment: TwoLevelDisplayAlignment.fromTop,
          height: 100,
          canTwoLevelText: "Тягни ще більше для секретного рівня 🚀",
          twoLevelWidget: _buildTwoLevelView(),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
          ),
        ),
        onTwoLevel: (isOpened) {
          setState(() {
            _isTwoLevelOpened = isOpened;
          });
        },
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