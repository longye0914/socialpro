import 'package:event_bus/event_bus.dart';

EventBus eventChatRefreshBus = EventBus();
class ChatRefreshEvent {
  bool isRefresh;
  ChatRefreshEvent(bool isRefresh){
    this.isRefresh = isRefresh;
  }
}