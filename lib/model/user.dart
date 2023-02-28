import 'dart:convert';

import 'package:habit_tracker/model/habit.dart';

class User {
  String id;
  String name;
  String imagePath;
  bool isUrl;
  int noOfHabits;
  int streaks;
  int targetStreaks;
  List<Habit> habits;
  bool isEmpty;
  int indexInArray;

  User(
      {required this.id,
      required this.name,
      required this.imagePath,
      required this.isUrl,
      required this.noOfHabits,
      required this.streaks,
      required this.targetStreaks,
      required this.habits,
      required this.isEmpty,
      required this.indexInArray});

  factory User.empty() {
    return User(
        id: "",
        name: "",
        imagePath: "",
        isUrl: false,
        noOfHabits: 0,
        streaks: 0,
        targetStreaks: 0,
        habits: [],
        isEmpty: true,
        indexInArray: 0);
  }
  factory User.fromJson(String res) {
    var json = jsonDecode(res);
    return User(
        id: json['id'],
        name: json['name'],
        imagePath: json['imagePath'],
        isUrl: json['isUrl'],
        noOfHabits: json['noOfHabits'],
        streaks: json['streaks'],
        targetStreaks: json['targetStreaks'],
        habits: (json['habits'] as List)
            .map((item) => jsonEncode(item))
            .toList()
            .map((item) => Habit.fromJson(item))
            .toList(),
        isEmpty: false,
        indexInArray: 0);
  }

  Map toJson() => {
        "id": id,
        "name": name,
        "imagePath": imagePath,
        "isUrl": isUrl,
        "noOfHabits": noOfHabits,
        "streaks": streaks,
        "targetStreaks": targetStreaks,
        "habits": habits.map((e) => e.toJson()).toList(),
        "isEmpty": false,
        "indexInArray": 0
      };
}
