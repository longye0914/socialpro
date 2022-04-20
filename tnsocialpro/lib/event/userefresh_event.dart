import 'package:event_bus/event_bus.dart';

EventBus userRefreshBus = EventBus();
class UserRefreshEvent {
  bool isRefresh;
  UserRefreshEvent(bool isRefresh){
    this.isRefresh = isRefresh;
  }
}