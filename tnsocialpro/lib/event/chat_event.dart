import 'package:event_bus/event_bus.dart';

EventBus eventChatBus = EventBus();
class ChatEvent {
  bool isStop;
  ChatEvent(bool isStop){
    this.isStop = isStop;
  }
}