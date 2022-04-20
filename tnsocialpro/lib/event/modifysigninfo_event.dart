//Bus初始化
import 'package:event_bus/event_bus.dart';

EventBus modifySigninfoBus = EventBus();
class ModifySigninfoEvent {
  String text;
  ModifySigninfoEvent(String text){
    this.text = text;
  }
}