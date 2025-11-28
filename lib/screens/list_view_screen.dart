import 'package:flutter/material.dart';

class ListViewScreen extends StatelessWidget {
  final List<String> contacts = List.generate(30, (i) => 'Contact ${i + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts (ListView)')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final name = contacts[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 24,
              child: Icon(Icons.person, size: 28),
            ),
            title: Text(name),
            subtitle: Text('phone: 0123-456-78${index % 10}'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected: $name')),
              );
            },
          );
        },
      ),
    );
  }
}
