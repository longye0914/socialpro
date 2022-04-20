import 'package:event_bus/event_bus.dart';

EventBus eventMaintabBus = EventBus();
class MainTabEvent {
  int index;
  MainTabEvent(int index){
    this.index = index;
  }
}