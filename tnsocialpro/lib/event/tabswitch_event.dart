import 'package:event_bus/event_bus.dart';

EventBus tabSwitchBus = EventBus();
class TabSwitchBus {
  int indexVal;
  TabSwitchBus(int indexVal){
    this.indexVal = indexVal;
  }
}