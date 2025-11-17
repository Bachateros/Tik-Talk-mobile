import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:tik_talk/data/datasources/db/app_db.dart';
import 'ws_event_bus.dart';

class WebSocketService {
  final String baseUrl;
  final String token;
  final AppDb db;

  WebSocketChannel? _channel;
  bool _isConnecting = false;

  WebSocketService({required this.baseUrl, required this.token, required this.db,});

  bool get isConnecting => _isConnecting;

  Future<void> connect() async {
      if (_isConnecting || _channel != null) return;
    _isConnecting = true;

    try {
      _channel = IOWebSocketChannel.connect(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
        pingInterval: null,  
      // pingInterval: const Duration(seconds: 30),
      );
      print('[WS] Connected to $baseUrl');

      _channel!.stream.listen(
        (event) {
          final data = jsonDecode(event);
          WsEventBus().add(data);
        },
        onError: (err) {
          print('[WS] Stream error: $err');
          _reconnect();
        },
        onDone: () {
          print('[WS] Connection closed');
          _reconnect();
        },
      );

    } catch (e) {
      print('[WS] Connection error: $e');
      _reconnect();
    } finally {
      _isConnecting = false;
    }
  }


  void _reconnect() async {
    if (_isConnecting) return;
    _isConnecting = true;

    await Future.delayed(const Duration(seconds: 5));
    print('[WS] Reconnecting...');
    _isConnecting = false;
    connect();
  }

  void Close() {
    print('WebSocket closed');
  }


  void dispose() {
    _channel?.sink.close();
  }
}