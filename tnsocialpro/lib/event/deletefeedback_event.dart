//Bus初始化
import 'package:event_bus/event_bus.dart';

EventBus deleteFeedbackBus = EventBus();

class DeleteFeedEvent {
  String text;
  DeleteFeedEvent(String text) {
    this.text = text;
  }
}
