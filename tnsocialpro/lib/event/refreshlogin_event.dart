import 'package:event_bus/event_bus.dart';

EventBus refreshLoginBus = EventBus();

class RefreshLoginEvent {
  bool isRefresh;
  RefreshLoginEvent(bool isRefresh) {
    this.isRefresh = isRefresh;
  }
}
