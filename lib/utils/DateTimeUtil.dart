import 'package:intl/intl.dart';

class DateTimeUtilNoteApp {
  static String generateTime() {
    return "${DateFormat.yMMMd().format(DateTime.now())} , ${DateTime.now().hour}: ${DateTime.now().minute}: ${DateTime.now().second}";
  }
}
