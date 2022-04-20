//Bus初始化
import 'package:event_bus/event_bus.dart';

EventBus myvoiceBus = EventBus();

class MyVoiceEvent {
  String text;
  MyVoiceEvent(String text) {
    this.text = text;
  }
}
