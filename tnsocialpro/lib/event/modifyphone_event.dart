//Bus初始化
import 'package:event_bus/event_bus.dart';

EventBus modifyPhoneBus = EventBus();

class ModifyPhoneEvent {
  String text;
  ModifyPhoneEvent(String text) {
    this.text = text;
  }
}
