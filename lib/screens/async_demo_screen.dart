import 'package:flutter/material.dart';

class AsyncDemoScreen extends StatefulWidget {
  @override
  _AsyncDemoScreenState createState() => _AsyncDemoScreenState();
}

class _AsyncDemoScreenState extends State<AsyncDemoScreen> {
  String _message = 'Press button to load user';

  Future<void> _loadUser() async {
    setState(() => _message = 'Loading user...');
    await Future.delayed(const Duration(seconds: 3));
    setState(() => _message = 'User loaded successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Async Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_message, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadUser, child: const Text('Load User (3s)')),
          ],
        ),
      ),
    );
  }
}
