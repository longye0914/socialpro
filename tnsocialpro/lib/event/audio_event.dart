import 'package:event_bus/event_bus.dart';

EventBus eventAudioBus = EventBus();
class AudioEvent {
  bool isStop;
  AudioEvent(bool isStop){
    this.isStop = isStop;
  }
}