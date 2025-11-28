import 'dart:async';
import 'dart:isolate';
import 'dart:math';

void main() async {
  final receivePort = ReceivePort();
  final isolate = await Isolate.spawn(worker, receivePort.sendPort);

  final controlPort = ReceivePort();
  // The worker will send its SendPort as the first message
  final workerSendPort = await receivePort.first as SendPort;

  int sum = 0;
  final sub = receivePort.listen((message) {
    if (message is int) {
      sum += message;
      print('Main received $message, sum = $sum');
      if (sum > 100) {
        print('Sum > 100, sending stop');
        workerSendPort.send(['STOP', controlPort.sendPort]);
      }
    } else if (message is String) {
      print('Main got message: $message');
    }
  });

  // Wait for worker to confirm exit
  await for (final msg in controlPort) {
    if (msg == 'EXITED') {
      print('Worker exited gracefully');
      break;
    }
  }

  await sub.cancel();
  receivePort.close();
  controlPort.close();
  isolate.kill(priority: Isolate.immediate);
  print('Main done');
}

void worker(SendPort initialReplyTo) {
  final random = Random();
  final receive = ReceivePort();
  initialReplyTo.send(receive.sendPort);

  Timer? timer;
  timer = Timer.periodic(Duration(seconds: 1), (_) {
    final val = random.nextInt(20) + 1;
    initialReplyTo.send(val); // send to main
  });

  receive.listen((message) {
    if (message is List && message.isNotEmpty && message[0] == 'STOP') {
      timer?.cancel();
      final SendPort replyPort = message[1] as SendPort;
      replyPort.send('EXITED');
      Isolate.exit(); // graceful exit
    }
  });
}
