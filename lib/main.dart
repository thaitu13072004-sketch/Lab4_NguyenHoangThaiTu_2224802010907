import 'package:flutter/material.dart';
import 'screens/list_view_screen.dart';
import 'screens/grid_view_screen.dart';
import 'screens/shared_prefs_screen.dart';
import 'screens/async_demo_screen.dart';
import 'screens/isolate_factorial_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab Exercises',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final tiles = [
    {'title': '1. List View', 'screen': ListViewScreen()},
    {'title': '2. Grid View', 'screen': GridViewScreen()},
    {'title': '3. Shared Preferences', 'screen': SharedPrefsScreen()},
    {'title': '4. Async Demo', 'screen': AsyncDemoScreen()},
    {'title': '5. Isolate Factorial', 'screen': IsolateFactorialScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab Exercises Hub')),
      body: ListView.builder(
        itemCount: tiles.length,
        itemBuilder: (context, i) {
          final t = tiles[i];
          return ListTile(
            title: Text(t['title'] as String),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => t['screen'] as Widget));
            },
          );
        },
      ),
    );
  }
}
