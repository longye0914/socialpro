//Bus初始化
import 'package:event_bus/event_bus.dart';

EventBus visitDeleteBus = EventBus();
class VisitDeleteEvent {
  bool isDelete;
  VisitDeleteEvent(bool isDelete){
    this.isDelete = isDelete;
  }
}