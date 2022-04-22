import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_challenge_day_two/database/DbHelper.dart';
import 'package:ui_challenge_day_two/screens/HomeScreen.dart';

import 'services/Routes.service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  var db;
  void startDB() async {
    db = await DBProvider.localDBInstance.getDataBase();
  }

  @override
  Widget build(BuildContext context) {
    startDB();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: GoogleFonts.openSans().fontFamily,
        primarySwatch: Colors.blue,
      ),
      routes: ApplicationRouting.getRoutes(),
      initialRoute: ApplicationRouting.initialRoute(),
    );
  }
}
