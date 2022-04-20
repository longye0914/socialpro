//Bus初始化
import 'package:event_bus/event_bus.dart';

EventBus rechargeBus = EventBus();
class RechargeEvent {
  int type;
  String mon, tianVal;
  RechargeEvent(int type, String mon, String tianVal){
    this.type = type;
    this.mon = mon;
    this.tianVal = tianVal;
  }
}