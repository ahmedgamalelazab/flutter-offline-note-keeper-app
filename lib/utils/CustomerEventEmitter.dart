/**
 * @description Event Emitter design pattern in flutter
 */

class CustomEventEmitter {
  Map<String, List<Function>>? events;

  CustomEventEmitter() {
    events = {};
  }
  //on
  void on({String? event, Function? handler}) {
    if (events!.containsKey(event)) {
      events![event]!.add(handler!);
    } else {
      events![event!] = [];
      events![event]!.add(handler!);
    }
  }

  //off
  void off({String? event, Function? handler}) {
    if (events!.containsKey(event)) {
      var targetEventHandler = events![event]!.where((eventsHandler) {
        return eventsHandler == handler;
      }).toList()[0];
      events![event]!.remove(targetEventHandler);
    }
  }

  //emit
  void emit({String? event, Object? data}) {
    if (events!.containsKey(event)) {
      //loop through out all of the handlers and call them
      for (var handler in events![event]!) {
        handler(data);
      }
    }
  }
}
