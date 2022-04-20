//Bus初始化
import 'package:event_bus/event_bus.dart';

EventBus modifyHeadBus = EventBus();
class ModifyHeadEvent {
  String text;
  ModifyHeadEvent(String text){
    this.text = text;
  }
}