import 'package:event_bus/event_bus.dart';

EventBus eventMessagetabBus = EventBus();
class MessageTabEvent {
  int index;
  MessageTabEvent(int index){
    this.index = index;
  }
}