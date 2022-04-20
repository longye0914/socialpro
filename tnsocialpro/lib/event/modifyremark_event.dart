//Bus初始化
import 'package:event_bus/event_bus.dart';

EventBus modifyRemarkBus = EventBus();

class ModifyRemarkEvent {
  String text;
  ModifyRemarkEvent(String text) {
    this.text = text;
  }
}
