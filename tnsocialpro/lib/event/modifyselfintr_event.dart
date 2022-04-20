//Bus初始化
import 'package:event_bus/event_bus.dart';

EventBus modifySelfintrBus = EventBus();
class ModifyIntroEvent {
  String text;
  ModifyIntroEvent(String text){
    this.text = text;
  }
}