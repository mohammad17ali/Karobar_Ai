
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebSocketService {
  late WebSocketChannel channel;
  final Function(Order) onOrderUpdate;
  final String token;

  WebSocketService({required this.onOrderUpdate, required this.token}) {
    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    channel = WebSocketChannel.connect(
      Uri.parse('wss://your-websocket-url.com/ws?token=$token'),
    );

    channel.stream.listen(
      (message) {
        final data = json.decode(message);
        if (data['type'] == 'ORDER_UPDATE') {
          final order = Order.fromJson(data['order']);
          onOrderUpdate(order);
        }
      },
      onError: (error) {
        print('WebSocket Error: $error');
      },
      onDone: () {
        print('WebSocket Connection Closed');
      },
    );
  }

  void dispose() {
    channel.sink.close();
  }
}
