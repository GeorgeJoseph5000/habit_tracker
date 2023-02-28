import 'dart:convert';

import 'package:flutter/material.dart';

class Habit {
  String id;
  String title;
  List<int> dateCreated;
  List<int> timeInDay;
  int streak;
  int targetStreak;
  int highScore;
  String imagePath;
  bool isUrl;
  bool doneToday;
  List<int> lastDayDone;
  String description;
  int indexInArray;
  bool achieved;

  Habit(
      {required this.id,
      required this.title,
      required this.dateCreated,
      required this.timeInDay,
      required this.streak,
      required this.highScore,
      required this.targetStreak,
      required this.imagePath,
      required this.isUrl,
      required this.doneToday,
      required this.lastDayDone,
      required this.description,
      required this.indexInArray,
      required this.achieved});

  static String timeToString(TimeOfDay time, BuildContext context) {
    return time.format(context);
  }

  static List<int> timeToList(TimeOfDay time) {
    return [time.hour, time.minute];
  }

  static TimeOfDay listToTime(List time) {
    return TimeOfDay(hour: time[0], minute: time[1]);
  }

  static String dateToString(DateTime date) {
    return date.day.toString() +
        "/" +
        date.month.toString() +
        "/" +
        date.year.toString();
  }

  static List<int> dateToList(DateTime date) {
    return [date.day, date.month, date.year];
  }

  static DateTime listToDate(List date) {
    return DateTime(date[2], date[1], date[0],);
  }

  factory Habit.empty() {
    return Habit(
        id: "",
        title: "",
        dateCreated: dateToList(DateTime.now()),
        timeInDay: timeToList(TimeOfDay.now()),
        streak: 0,
        highScore: 0,
        targetStreak: 0,
        imagePath: "",
        isUrl: true,
        doneToday: false,
        lastDayDone: [],
        description: "",
        indexInArray: 0,
        achieved: false);
  }

  factory Habit.fromJson(String res) {
    Map<String, dynamic> json = jsonDecode(res);
    print(res);
    List<int> dateCreated = [];
    List<int> timeInDay = [];
    List<int> lastDayDone = [];
    (json["dateCreated"] as List).forEach((element) {
      dateCreated.add(element);
    });
    (json["timeInDay"] as List).forEach((element) {
      timeInDay.add(element);
    });
    (json["lastDayDone"] as List).forEach((element) {
      lastDayDone.add(element);
    });
    print(dateCreated.runtimeType);    

    return Habit(
        id: json["id"],
        title: json["title"],
        dateCreated: dateCreated,
        timeInDay: timeInDay,
        streak: json["streak"],
        highScore: json["highScore"],
        targetStreak: json["targetStreak"],
        imagePath: json["imagePath"],
        isUrl: json["isUrl"],
        doneToday: json["doneToday"],
        lastDayDone: lastDayDone,
        description: json["description"],
        indexInArray: json['indexInArray'],
        achieved: json['achieved']);
  }

  Map toJson() => {
        "id": id,
        "title": title,
        "dateCreated": dateCreated,
        "timeInDay": timeInDay,
        "streak": streak,
        "highScore": highScore,
        "targetStreak": targetStreak,
        "imagePath": imagePath,
        "isUrl": isUrl,
        "doneToday": doneToday,
        "lastDayDone": lastDayDone,
        "description": description,
        "achieved": achieved,
        "indexInArray": indexInArray
      };
}
