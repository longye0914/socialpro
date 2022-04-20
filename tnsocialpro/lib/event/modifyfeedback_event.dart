//Bus初始化
import 'package:event_bus/event_bus.dart';

EventBus modifyFeedbackBus = EventBus();

class ModifyFeedEvent {
  String text;
  ModifyFeedEvent(String text) {
    this.text = text;
  }
}
