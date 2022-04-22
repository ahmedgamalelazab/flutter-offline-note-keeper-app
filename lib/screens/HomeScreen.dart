import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ui_challenge_day_two/Models/Note.dart';
import 'package:ui_challenge_day_two/constants/projectColors.dart';
import 'package:ui_challenge_day_two/database/DbHelper.dart';
import 'package:ui_challenge_day_two/screens/EditNotes.dart';

import '../utils/CustomerEventEmitter.dart';
import '../utils/DateTimeUtil.dart';

class HomeScreen extends StatefulWidget {
  static const String ScreenRoute = "/";
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notesList = [];
  final _scrollController = ScrollController(initialScrollOffset: 0);
  final CustomEventEmitter eventEmitter = CustomEventEmitter();
  int _initialIndex = 0;

  Future<void> addNote(
      {required int lastIndex,
      required String title,
      required String description,
      required String colorTheme}) async {
    Note newNote = Note(
        id: ++lastIndex,
        title: title,
        description: description,
        date: DateTimeUtilNoteApp.generateTime(),
        createdAt: DateTimeUtilNoteApp.generateTime(),
        updatedAt: DateTimeUtilNoteApp.generateTime(),
        backgroundColor: colorTheme);
    setState(() {
      notesList.add(newNote);
    });
    await DBProvider.localDBInstance.newNote(newNote);
  }

  //register delete event
  void deleteUserNoteEvent(data) {
    //delete the note
    showOkCancelAlertDialog(
        context: context,
        message: "are you sure ?",
        okLabel: "yes",
        cancelLabel: "cancel",
        builder: (context, widget) {
          return ListView(
            children: [widget], // for very small screens
          );
        }).then((result) async {
      if (result == OkCancelResult.ok) {
        //user agrees on deleting the Note
        DBProvider.localDBInstance.deleteNote(data).then((value) {
          setState(() {});
        });
      } else {
        //handle else state or do nothing
      }
    });
  }

  @override
  void initState() {
    eventEmitter.on(
        event: "userNotedUpdated",
        handler: (data) {
          setState(() {
            print(data);
          });
        });
    eventEmitter.on(
      event: "onDeleteUserNote",
      handler: deleteUserNoteEvent,
    );
    // eventEmitter.off(
    //     event: "onDeleteUserNote",
    //     handler: deleteUserNoteEvent); // test purpose only
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // print(screenWidth * 0.4);
    return FutureBuilder(
        future: DBProvider.localDBInstance.getDataBase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
                future: DBProvider.localDBInstance.getNotes(),
                builder: ((context, dataSnapShot) {
                  if (dataSnapShot.hasData) {
                    notesList = dataSnapShot.data as List<Note>;
                    // print(notesList.length);
                    if (notesList.isEmpty) {
                      return Scaffold(
                        floatingActionButton: FloatingActionButton(
                          onPressed: () async {
                            //call callback to add a new note

                            //open show dialogue
                            var result = await showTextInputDialog(
                              title: "New Note",
                              // message: "Note Data",
                              okLabel: "Confirm",
                              cancelLabel: "Cancel",
                              context: context,
                              actionsOverflowDirection: VerticalDirection.down,
                              builder: (context, widget) {
                                return ListView(
                                  children: [widget],
                                );
                              },
                              textFields: [
                                DialogTextField(
                                  hintText: "Title",
                                  validator: (userInput) {
                                    if (userInput!.isEmpty) {
                                      return "Note Cannot be empty";
                                    } else if (userInput.length >= 10) {
                                      return "title can't take to much data";
                                    }
                                    return null;
                                  },
                                ),
                                DialogTextField(
                                    hintText: "description",
                                    validator: (userInput) {
                                      if (userInput!.isEmpty) {
                                        return "you must give the note description";
                                      }
                                      return null;
                                    }),
                                DialogTextField(
                                  hintText: "theme : green , yellow , pink",
                                  validator: (userInput) {
                                    if (userInput!
                                            .toLowerCase()
                                            .contains("green") ||
                                        userInput
                                            .toLowerCase()
                                            .contains("yellow") ||
                                        userInput
                                            .toLowerCase()
                                            .contains("pink")) {
                                      return null;
                                    }
                                    return "you must pick from green yellow pink";
                                  },
                                ),
                              ],
                            );
                            if (result != null) {
                              if (result.isNotEmpty) {
                                //handle the case of the first time insertion
                                if (notesList.isEmpty) {
                                  await addNote(
                                      lastIndex: 1,
                                      title: result[0],
                                      description: result[1],
                                      colorTheme: result[2]);
                                } else {
                                  await addNote(
                                      lastIndex: notesList.last.id!,
                                      title: result[0],
                                      description: result[1],
                                      colorTheme: result[2]);
                                }
                              }
                            }
                          },
                          backgroundColor: Constants.KPinkColor,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 300,
                              sigmaY: 300,
                              tileMode: TileMode.mirror,
                            ),
                            child: Container(
                              width: 100,
                              height: 100,
                              alignment: Alignment.center,
                              child: const Text(
                                "+",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.pinkAccent),
                            ),
                          ),
                        ),
                        backgroundColor: Constants.KBlackColor,
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.3,
                              height: screenWidth * 0.3,
                              child:
                                  Image.asset('assets/images/unavaialable.png'),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: const Text(
                                "No Notes Available !",
                                style: TextStyle(
                                    fontSize: 25, color: Constants.KWhiteColor),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Scaffold(
                        extendBody: true,
                        floatingActionButton: FloatingActionButton(
                          onPressed: () async {
                            //call callback to add a new note

                            //open show dialogue
                            var result = await showTextInputDialog(
                              title: "New Note",
                              // message: "Note Data",
                              okLabel: "Confirm",
                              cancelLabel: "Cancel",
                              context: context,
                              actionsOverflowDirection: VerticalDirection.down,
                              builder: (context, widget) {
                                return ListView(
                                  children: [widget],
                                );
                              },
                              textFields: [
                                DialogTextField(
                                  hintText: "Title",
                                  validator: (userInput) {
                                    if (userInput!.isEmpty) {
                                      return "Note Cannot be empty";
                                    } else if (userInput.length >= 10) {
                                      return "title can't take to much data";
                                    }
                                    return null;
                                  },
                                ),
                                DialogTextField(
                                    hintText: "description",
                                    validator: (userInput) {
                                      if (userInput!.isEmpty) {
                                        return "you must give the note description";
                                      }
                                      return null;
                                    }),
                                DialogTextField(
                                  hintText: "theme : green , yellow , pink",
                                  validator: (userInput) {
                                    if (userInput!
                                            .toLowerCase()
                                            .contains("green") ||
                                        userInput
                                            .toLowerCase()
                                            .contains("yellow") ||
                                        userInput
                                            .toLowerCase()
                                            .contains("pink")) {
                                      return null;
                                    }
                                    return "you must pick from green yellow pink";
                                  },
                                ),
                              ],
                            );
                            if (result != null) {
                              if (result.isNotEmpty) {
                                await addNote(
                                    lastIndex: notesList.last.id!,
                                    title: result[0],
                                    description: result[1],
                                    colorTheme: result[2]);
                              }
                            }
                          },
                          backgroundColor: Constants.KPinkColor,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 0,
                              sigmaY: 0,
                              tileMode: TileMode.mirror,
                            ),
                            child: Container(
                              width: 100,
                              height: 100,
                              alignment: Alignment.center,
                              child: const Text(
                                "+",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.pinkAccent),
                            ),
                          ),
                        ),
                        backgroundColor: Constants.KBlackColor,
                        body: ListView.builder(
                            // shrinkWrap: true,
                            itemCount: notesList.length,
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              // print(notesList[index].backgroundColor);
                              //^need to see where i can grap this shit
                              return Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    height: screenHeight * 0.4,
                                    width: screenWidth * 0.7,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        bottomRight: Radius.circular(21),
                                      ),
                                      color: cardColorPicker(
                                          colorName: notesList[index]
                                              .backgroundColor
                                              .toString()), //TODO
                                    ),
                                    child: Column(children: [
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: Constants.KWhiteColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(40),
                                          ),
                                        ),
                                        width: screenWidth * 0.8,
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          "${notesList[index].title}",
                                          style: const TextStyle(
                                            fontSize: 22,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ListView(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                // color: Colors.red,
                                                child: Text(
                                                    "${notesList[index].description}",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    )),
                                              )
                                            ],
                                          ),
                                          Positioned(
                                            left: 0,
                                            bottom: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              alignment: Alignment.centerLeft,
                                              height: 40,
                                              width: screenWidth * 0.7,
                                              decoration: const BoxDecoration(
                                                // shape: BoxShape.circle,
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                ),
                                                color: Constants.KWhiteColor,
                                              ),
                                              child: Text(
                                                "${notesList[index].updatedAt} ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      right: 5,
                                                    ),
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: cardColorPicker(
                                                          colorName: notesList[
                                                                  index]
                                                              .backgroundColor
                                                              .toString()),
                                                    ),
                                                    child: IconButton(
                                                        onPressed: () {
                                                          //^delete the component
                                                          //^handle the delete state
                                                          eventEmitter.emit(
                                                              event:
                                                                  "onDeleteUserNote",
                                                              data: notesList[
                                                                  index]);
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: cardColorPicker(
                                                          colorName: notesList[
                                                                  index]
                                                              .backgroundColor
                                                              .toString()),
                                                    ),
                                                    child: IconButton(
                                                        onPressed: () {
                                                          //^navigate to edit screen
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                                  NotesEditScreen
                                                                      .ScreenRoute,
                                                                  arguments: {
                                                                "userNote":
                                                                    notesList[
                                                                        index],
                                                                "eventEmitter":
                                                                    eventEmitter
                                                              });
                                                        },
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ))
                                    ]),
                                  ),
                                ],
                              );
                            }),
                      );
                    }
                  } else {
                    return const Scaffold(
                      backgroundColor: Constants.KBlackColor,
                      body: Center(
                        child: CircularProgressIndicator(
                          color: Constants.KPinkColor,
                          backgroundColor: Constants.KWhiteColor,
                        ),
                      ),
                    );
                  }
                }));
          } else {
            return const Scaffold(
              backgroundColor: Constants.KBlackColor,
              body: Center(
                child: CircularProgressIndicator(
                  color: Constants.KPinkColor,
                  backgroundColor: Constants.KWhiteColor,
                ),
              ),
            );
          }
        });
  }
}

Color? cardColorPicker({required String? colorName}) {
  Map<String, Color> colorList = {
    "green": Constants.KGreenColor,
    "yellow": Constants.KYellowColor,
    "pink": Constants.KPinkColor,
  };

  return colorList[colorName] ?? Constants.KYellowColor;
}
