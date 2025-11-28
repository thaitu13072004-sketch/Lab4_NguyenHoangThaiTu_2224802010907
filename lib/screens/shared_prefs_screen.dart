import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsScreen extends StatefulWidget {
  @override
  _SharedPrefsScreenState createState() => _SharedPrefsScreenState();
}

class _SharedPrefsScreenState extends State<SharedPrefsScreen> {
  final _controllerName = TextEditingController();
  String _display = 'Chưa có dữ liệu';

  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _controllerName.text);
    await prefs.setString('saved_at', DateTime.now().toIso8601String());
    setState(() => _display = 'Đã lưu tên: ${_controllerName.text}');
  }

  Future<void> _showName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('username');
    final time = prefs.getString('saved_at');
    setState(() {
      if (name == null || name.isEmpty) {
        _display = 'Chưa tìm thấy tên đã lưu';
      } else {
        _display = 'Tên: $name\nLưu lúc: ${time ?? 'không có'}';
      }
    });
  }

  Future<void> _clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('saved_at');
    setState(() => _display = 'Dữ liệu đã xóa');
  }

  @override
  void dispose() {
    _controllerName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shared Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controllerName,
              decoration: InputDecoration(labelText: 'Enter name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: _saveName, child: const Text('Save Name'))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: _showName, child: const Text('Show Name'))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: _clear, child: const Text('Clear'))),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // bonus: save age/email quickly
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('age', 21);
                      await prefs.setString('email', 'student@example.com');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã lưu age/email ví dụ')));
                    },
                    child: const Text('Bonus: Save age/email'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(_display),
          ],
        ),
      ),
    );
  }
}
