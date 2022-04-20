import 'package:event_bus/event_bus.dart';

EventBus eventRefreshMyfamBus = EventBus();

class RefreshMyfamEvent {
  bool isRefresh;
  RefreshMyfamEvent(bool isRefresh) {
    this.isRefresh = isRefresh;
  }
}
