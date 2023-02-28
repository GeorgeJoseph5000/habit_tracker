import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:habit_tracker/providers/user_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../model/habit.dart';
import '../ui/habit_entry.dart';

class MoreInfo extends StatefulWidget {
  Habit habit;
  MoreInfo(this.habit, {Key? key}) : super(key: key);

  @override
  State<MoreInfo> createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  late Uint8List _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController _screenshotController = ScreenshotController();
  
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.title),
        actions: [
          IconButton(
              onPressed: () async {
                _screenshotController
                    .capture(delay: const Duration(milliseconds: 10))
                    .then((Uint8List? image) async {
                  if (image != null) {
                    final directory = await getApplicationDocumentsDirectory();
                    final imagePath =
                        await File('${directory.path}/image.png').create();
                    await imagePath.writeAsBytes(image);

                    /// Share Plugin
                    await Share.shareFiles([imagePath.path]);
                  }
                });
              },
              icon: Icon(Icons.share_sharp))
        ],
      ),
      body: ListView(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Screenshot(
              controller: _screenshotController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: widget.habit.isUrl
                                ? Image.network(
                                    widget.habit.imagePath,
                                    width: 100,
                                  )
                                : Text("")),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.habit.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              Text(Habit.timeToString(
                                  Habit.listToTime(widget.habit.timeInDay),
                                  context)),
                              const Text(
                                "Date started:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(Habit.dateToString(
                                  Habit.listToDate(widget.habit.dateCreated))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  /* Numbers of streak */
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text("Streak:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              widget.habit.streak.toString(),
                              textScaleFactor: 3,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Target Streak:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              widget.habit.targetStreak.toString(),
                              textScaleFactor: 3,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("High Score:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              widget.habit.highScore.toString(),
                              textScaleFactor: 3,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  /* Description */
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(widget.habit.description),
                  ),
                ],
              ),
            ),
            /* Buttons */
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        userProvider.deleteHabit(widget.habit);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.delete),
                      label: Text("Delete")),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await setHabitDone(widget.habit, userProvider);
                    },
                    icon: Icon(Icons.done),
                    label: Text("Done"),
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                          color: widget.habit.doneToday
                              ? Colors.blue
                              : Colors.white,
                          width: 2),
                      backgroundColor:
                          widget.habit.doneToday ? Colors.blue : Colors.white,
                      foregroundColor:
                          widget.habit.doneToday ? Colors.white : Colors.blue,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }
}
