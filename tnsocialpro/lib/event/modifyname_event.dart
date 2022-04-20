//Bus初始化
import 'package:event_bus/event_bus.dart';

EventBus modifyNameBus = EventBus();
class ModifyNameEvent {
  String text;
  ModifyNameEvent(String text){
    this.text = text;
  }
}