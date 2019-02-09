import 'dart:convert';
import 'dart:io';

import 'package:centrifuge/centrifuge.dart' as centrifuge;

void main() async {
  final url = 'ws://localhost:8000/connection/websocket?format=protobuf';
  final channel = 'chat';

  final onEvent = (dynamic event) {
    print('$channel> $event');
  };

  try {
    final client = centrifuge.createClient(
      url,
      config: centrifuge.ClientConfig(
        headers: <String, dynamic>{'user-id': 42, 'user-name': 'The Answer'},
      ),
    );

    centrifuge.Subscription subscriptionHandler;

    client.connectStream.listen((event) async {
      onEvent(event);

      final subscription = client.subscribe(channel);

      subscription.publishStream
          .map((e) => utf8.decode(e.data))
          .listen(onEvent);

      subscription.joinStream.listen(onEvent);
      subscription.leaveStream.listen(onEvent);

      subscription.subscribeSuccessStream.listen((event) {
        onEvent(event);
        subscriptionHandler = subscription;
      });
      subscription.subscribeErrorStream.listen((event) {
        onEvent(event);
        subscriptionHandler = null;
      });
      subscription.unsubscribeStream.listen((event) {
        onEvent(event);
        subscriptionHandler = null;
      });
    });

    client.disconnectStream.listen(onEvent);
    client.connect();

    await for (List<int> codeUnit in stdin) {
      final message = utf8.decode(codeUnit).trim();
      print('message = $message');

      await processInput(message, subscriptionHandler, client);
    }
  } catch (ex) {
    print(ex);
  }
}

Future processInput(String message, centrifuge.Subscription subscriptionHandler,
    centrifuge.Client client) async {
  switch (message) {
    case '#subscribe':
      await subscriptionHandler.subscribe();
      break;
    case '#unsubscribe':
      await subscriptionHandler.unsubscribe();
      break;
    case '#connect':
      client.connect();
      break;
    case '#disconnect':
      client.disconnect();
      break;
    default:
      final output = jsonEncode({'input': message});
      final data = utf8.encode(output);
      if (subscriptionHandler == null) {
        print('> No subscription');
      } else {
        subscriptionHandler.publish(data);
      }
      break;
  }
  return;
}
