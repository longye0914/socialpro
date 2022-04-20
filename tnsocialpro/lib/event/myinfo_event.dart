import 'package:event_bus/event_bus.dart';

EventBus myinfolistBus = EventBus();
class MyinfolistEvent {
  bool isRefresh;
  MyinfolistEvent(bool isRefresh){
    this.isRefresh = isRefresh;
  }
}