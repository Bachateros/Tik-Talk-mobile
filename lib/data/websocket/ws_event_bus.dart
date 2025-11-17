import 'dart:async';

class WsEventBus {
  static final WsEventBus _instance = WsEventBus._internal();
  factory WsEventBus() => _instance;
  WsEventBus._internal();

  final StreamController<Map<String, dynamic>> _controller =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void add(Map<String, dynamic> event) {
    _controller.add(event);
  }
}
