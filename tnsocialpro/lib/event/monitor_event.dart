import 'package:event_bus/event_bus.dart';

EventBus eventMonitorBus = EventBus();
class MonitorEvent {
  bool isRefresh;
  MonitorEvent(bool isRefresh){
    this.isRefresh = isRefresh;
  }
}