import 'package:event_bus/event_bus.dart';

EventBus eventLoginoutBus = EventBus();
class LoginoutEvent {
  bool isRefresh;
  LoginoutEvent(bool isRefresh){
    this.isRefresh = isRefresh;
  }
}