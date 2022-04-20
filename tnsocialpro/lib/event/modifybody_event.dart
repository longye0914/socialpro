//Bus初始化
import 'package:event_bus/event_bus.dart';

EventBus modifyBodyBus = EventBus();
class ModifyBodyEvent {
  String text;
  ModifyBodyEvent(String text){
    this.text = text;
  }
}