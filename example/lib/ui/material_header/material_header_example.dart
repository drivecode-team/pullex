import 'package:flutter/material.dart';
import 'package:pullex/pullex.dart';

enum MaterialHeaderType { Classic, WaterDrop }

class MaterialHeaderExample extends StatefulWidget {
  const MaterialHeaderExample({super.key});

  @override
  State<MaterialHeaderExample> createState() => _MaterialHeaderExampleState();
}

class _MaterialHeaderExampleState extends State<MaterialHeaderExample> {
  final PullexRefreshController _refreshController =
  PullexRefreshController(initialRefresh: false);

  MaterialHeaderType _headerType = MaterialHeaderType.Classic;

  List<int> items = List.generate(20, (index) => index);

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    setState(() {
      items = List.generate(20, (index) => index);
    });
    _refreshController.refreshCompleted();
  }


  Widget _buildHeader() {
    switch (_headerType) {
      case MaterialHeaderType.Classic:
        return const MaterialHeader(
          color: Colors.blue,
          backgroundColor: Colors.white,
        );
      case MaterialHeaderType.WaterDrop:
        return const WaterDropMaterialHeader(
          color: Colors.blue,
          backgroundColor: Colors.white,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Material Header Example')),
      body: Column(
        children: [
          Expanded(
            child: PullexRefresh(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: false,
              header: _buildHeader(),
              onRefresh: _onRefresh,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  Text(
                    'Select Header Type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ...MaterialHeaderType.values.map((type) {
                    return RadioListTile<MaterialHeaderType>(
                      title: Text(type.toString().split('.').last),
                      value: type,
                      groupValue: _headerType,
                      onChanged: (value) {
                        setState(() {
                          _headerType = value!;
                        });
                      },
                    );
                  }).toList(),
                  const Divider(),
                  ...items.map((i) => ListTile(title: Text('Item $i'))).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
