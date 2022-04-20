import 'package:event_bus/event_bus.dart';

EventBus videoshowBus = EventBus();

class VideoshowEvent {
  int daily_id;
  VideoshowEvent(int daily_id) {
    this.daily_id = daily_id;
  }
}
