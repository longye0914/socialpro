import 'package:event_bus/event_bus.dart';

EventBus reportReadBus = EventBus();
class ReportReadEvent {
  int reportId;
  ReportReadEvent(int reportId){
    this.reportId = reportId;
  }
}