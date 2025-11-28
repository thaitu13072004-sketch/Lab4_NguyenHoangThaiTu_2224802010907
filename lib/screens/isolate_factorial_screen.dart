import 'dart:isolate';
import 'package:flutter/material.dart';

class IsolateFactorialScreen extends StatefulWidget {
  @override
  _IsolateFactorialScreenState createState() => _IsolateFactorialScreenState();
}

class _IsolateFactorialScreenState extends State<IsolateFactorialScreen> {
  String _status = 'Idle';
  String _resultPreview = '';
  bool _isWorking = false;

  Future<void> _startFactorial(int n) async {
    setState(() {
      _isWorking = true;
      _status = 'Starting isolate...';
      _resultPreview = '';
    });

    final receivePort = ReceivePort();
    await Isolate.spawn(_factorialEntry, receivePort.sendPort);

    // First message from the spawned isolate will be its SendPort
    final sendPort = await receivePort.first as SendPort;

    final responsePort = ReceivePort();
    // send: [n, sendBackPort]
    sendPort.send([n, responsePort.sendPort]);

    // Listen for progress/result
    await for (final msg in responsePort) {
      if (msg is double) {
        setState(() => _status = 'Progress: ${(msg * 100).toStringAsFixed(1)}%');
      } else if (msg is String && msg.startsWith('RESULT:')) {
        final bigStr = msg.substring(7);
        // show only first/last 200 chars to avoid huge UI
        final preview = bigStr.length > 400
            ? '${bigStr.substring(0, 200)}\n...\n${bigStr.substring(bigStr.length - 200)}'
            : bigStr;
        setState(() {
          _status = 'Done';
          _resultPreview = preview;
          _isWorking = false;
        });
        responsePort.close();
        break;
      } else if (msg is String && msg.startsWith('ERROR:')) {
        setState(() {
          _status = 'Error: ${msg.substring(6)}';
          _isWorking = false;
        });
        responsePort.close();
        break;
      }
    }
  }

  static void _factorialEntry(SendPort initialReplyTo) async {
    final port = ReceivePort();
    // send back the SendPort so main isolate can communicate
    initialReplyTo.send(port.sendPort);

    await for (final message in port) {
      final n = message[0] as int;
      final SendPort reply = message[1] as SendPort;
      try {
        final stopwatch = Stopwatch()..start();
        // compute factorial as BigInt, but send periodic progress updates
        BigInt result = BigInt.one;
        final step = (n ~/ 100).clamp(1, n); // progress steps
        for (var i = 1; i <= n; i++) {
          result *= BigInt.from(i);
          if (i % step == 0 || i == n) {
            final progress = i / n;
            reply.send(progress);
          }
        }
        stopwatch.stop();
        // send result as string (very big). Be cautious.
        reply.send('RESULT:${result.toString()}');
      } catch (e) {
        reply.send('ERROR:$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: '5000'); // default safe value
    return Scaffold(
      appBar: AppBar(title: const Text('Isolate Factorial')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Note: 30000! rất lớn và có thể gây crash. Thử với giá trị nhỏ hơn (ví dụ 5000).'),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter n for n!', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isWorking ? null : () {
                final n = int.tryParse(controller.text) ?? 5000;
                _startFactorial(n);
              },
              child: const Text('Compute factorial in Isolate'),
            ),
            const SizedBox(height: 12),
            Text(_status),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_resultPreview, style: const TextStyle(fontFamily: 'monospace')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
