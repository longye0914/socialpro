import 'package:event_bus/event_bus.dart';

EventBus eventDeleteOldBus = EventBus();

class DeleteOldEvent {
  bool isRefresh;
  DeleteOldEvent(bool isRefresh) {
    this.isRefresh = isRefresh;
  }
}
