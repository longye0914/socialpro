//Bus初始化
import 'package:event_bus/event_bus.dart';

EventBus modifyPathBus = EventBus();
class ModifyPathEvent {
  String text;
  ModifyPathEvent(String text){
    this.text = text;
  }
}