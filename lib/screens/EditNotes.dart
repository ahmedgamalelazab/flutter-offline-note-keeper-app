import 'package:flutter/material.dart';
import 'package:ui_challenge_day_two/Models/Note.dart';
import 'package:ui_challenge_day_two/constants/projectColors.dart';
import 'package:ui_challenge_day_two/database/DbHelper.dart';
import 'package:ui_challenge_day_two/utils/CustomerEventEmitter.dart';

import '../utils/DateTimeUtil.dart';

class NotesEditScreen extends StatefulWidget {
  static const String ScreenRoute = 'NotesEditScreen';

  NotesEditScreen({Key? key}) : super(key: key);

  @override
  State<NotesEditScreen> createState() => _NotesEditScreenState();
}

class _NotesEditScreenState extends State<NotesEditScreen> {
  bool initStateTaken = false;
  Note userNoteToUpdate = Note();
  final formState = GlobalKey<FormState>();
  final userNoteBackGroundController = TextEditingController(text: "");
  final userNoteTitleController = TextEditingController(text: "");
  final userNoteDescriptionController = TextEditingController(text: "");
  var userNote;
  var eventEmitter;
  @override
  Widget build(BuildContext context) {
    if (initStateTaken == false) {
      userNote = (ModalRoute.of(context)!.settings.arguments
          as Map<String, dynamic>)["userNote"] as Note;
      eventEmitter = (ModalRoute.of(context)!.settings.arguments
          as Map<String, dynamic>)["eventEmitter"] as CustomEventEmitter;
      userNoteToUpdate.backgroundColor = userNote.backgroundColor;
      userNoteToUpdate.createdAt = userNote.createdAt;
      userNoteToUpdate.date = userNote.date;
      userNoteToUpdate.title = userNote.title;
      userNoteToUpdate.updatedAt = userNote.updatedAt;
      userNoteToUpdate.description = userNote.description;
      userNoteToUpdate.id = userNote.id;
      userNoteTitleController.text = userNote.title!;
      userNoteDescriptionController.text = userNote.description!;
      userNoteBackGroundController.text = userNote.backgroundColor!;
      initStateTaken = true;
    }

    print(userNote);
    print(eventEmitter);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Constants.KBlackColor,
      body: SafeArea(
        child: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              flex: 7,
              child: Container(
                // color: Colors.red,
                child: ListView(
                  children: [
                    Container(
                      // color: Colors.red,
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Form(
                          key: formState,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset('assets/images/edit.png'),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                // initialValue: userNote.title ?? "",
                                controller: userNoteTitleController,
                                validator: (userInput) {
                                  if (userInput!.isEmpty) {
                                    return "Pleas Fill the Field to Continue";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.title),
                                    fillColor: Constants.KWhiteColor,
                                    filled: true,
                                    hintText: "notes need title",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(6),
                                        bottomRight: Radius.circular(6),
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                // initialValue: userNote.description ?? "",
                                controller: userNoteDescriptionController,
                                validator: (userInput) {
                                  if (userInput!.isEmpty) {
                                    return "Pleas Fill the Field to Continue";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.description),
                                    fillColor: Constants.KWhiteColor,
                                    filled: true,
                                    hintText: "notes need description",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(6),
                                        bottomRight: Radius.circular(6),
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: userNoteBackGroundController,
                                // initialValue: userNote.backgroundColor ?? "",
                                validator: (userInput) {
                                  if (userInput!.isEmpty) {
                                    return "Pleas Fill the Field to Continue";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.color_lens),
                                    fillColor: Constants.KWhiteColor,
                                    filled: true,
                                    hintText: "notes need color Theme",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(6),
                                        bottomRight: Radius.circular(6),
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  //update the locale database
                                  if (formState.currentState!.validate()) {
                                    userNoteToUpdate.updatedAt =
                                        DateTimeUtilNoteApp.generateTime();
                                    userNoteToUpdate.backgroundColor =
                                        userNoteBackGroundController.text;
                                    userNoteToUpdate.title =
                                        userNoteTitleController.text;
                                    userNoteToUpdate.description =
                                        userNoteDescriptionController.text;
                                    try {
                                      await DBProvider.localDBInstance
                                          .updateNote(userNoteToUpdate);
                                      eventEmitter.emit(
                                          event: "userNotedUpdated",
                                          data: "updated");
                                      Navigator.of(context).pop(context);
                                    } catch (error) {
                                      print(error);
                                    }
                                  }
                                },
                                child: Text("Update"),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  userThemeColorPickerWidget(
                    color: Constants.KGreenColor,
                    shadowColor: Colors.green,
                    callback: () {
                      print("picked green");
                      userNoteToUpdate.backgroundColor = "green";
                      userNoteBackGroundController.text = "green";
                    },
                  ),
                  userThemeColorPickerWidget(
                    color: Constants.KPinkColor,
                    shadowColor: Colors.pink,
                    callback: () {
                      print("picked pink");
                      userNoteToUpdate.backgroundColor = "pink";
                      userNoteBackGroundController.text = "pink";
                    },
                  ),
                  userThemeColorPickerWidget(
                    color: Constants.KYellowColor,
                    shadowColor: Colors.yellow,
                    callback: () {
                      print("picked yellow");
                      userNoteToUpdate.backgroundColor = "yellow";
                      userNoteBackGroundController.text = "yellow";
                    },
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

Widget userThemeColorPickerWidget(
    {Color? color, Color? shadowColor, required Function callback}) {
  return ElevatedButton(
    onPressed: () {
      callback();
    },
    child: Container(),
    style: ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      primary: color,
      elevation: 8,
      shadowColor: shadowColor,
    ),
  );
}
