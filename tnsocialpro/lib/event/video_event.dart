import 'package:event_bus/event_bus.dart';

EventBus eventVideoBus = EventBus();
class VideoEvent {
  bool isStop;
  VideoEvent(bool isStop){
    this.isStop = isStop;
  }
}