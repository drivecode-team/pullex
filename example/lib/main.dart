import 'package:flutter/material.dart';
import 'package:pullex/pullex.dart';
import 'package:smart_pull_to_refresh_example/ui/base_header/base_header_example.dart';
import 'package:smart_pull_to_refresh_example/ui/custom_header/custom_header_example.dart';
import 'package:smart_pull_to_refresh_example/ui/load_more_base_header/load_more_base_header_example.dart';
import 'package:smart_pull_to_refresh_example/ui/material_header/material_header_example.dart';
import 'package:smart_pull_to_refresh_example/ui/stretch_header/stretch_header_example.dart';
import 'package:smart_pull_to_refresh_example/ui/two_level_refresh/two_level_refresh_example.dart';
import 'package:smart_pull_to_refresh_example/ui/water_drop_header/water_drop_header_example.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pullex Refresh Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const [
        PullexLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('uk'),
        Locale('ru'),
        Locale('fr'),
        Locale('de'),
        Locale('es'),
        Locale('it'),
        Locale('zh'),
        Locale('ja'),
        Locale('ko'),
        Locale('pt'),
        Locale('sv'),
        Locale('nl'),
      ],
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pullex Refresh Example')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Base Header Example'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const BaseHeaderExample(),
              ));
            },
          ),
          ListTile(
            title: const Text('Load More Base Header Example'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LoadMoreBaseHeaderExample(),
              ));
            },
          ),
          ListTile(
            title: const Text('TwoLevel Header Example'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const TwoLevelRefreshExample(),
              ));
            },
          ),
          ListTile(
            title: const Text('Stretch Header Example'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const StretchHeaderExample(),
              ));
            },
          ),
          ListTile(
            title: const Text('Water Drop Header Example'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const WaterDropHeaderExample(),
              ));
            },
          ),
          ListTile(
            title: const Text('Material Header Example'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const MaterialHeaderExample(),
              ));
            },
          ),
          ListTile(
            title: const Text('Custom Header Example'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CustomHeaderExample(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
