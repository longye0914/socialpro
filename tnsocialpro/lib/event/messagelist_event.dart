import 'package:event_bus/event_bus.dart';

EventBus messagelistBus = EventBus();

class MessagelistEvent {
  bool isRefresh;
  MessagelistEvent(bool isRefresh) {
    this.isRefresh = isRefresh;
  }
}
