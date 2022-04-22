import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:ui_challenge_day_two/screens/EditNotes.dart';
import 'package:ui_challenge_day_two/screens/HomeScreen.dart';

class ApplicationRouting {
  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      HomeScreen.ScreenRoute: (context) => HomeScreen(),
      NotesEditScreen.ScreenRoute: (context) => NotesEditScreen()
    };
  }

  static String initialRoute() {
    return HomeScreen.ScreenRoute;
  }
}
