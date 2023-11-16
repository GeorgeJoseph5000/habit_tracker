import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/model/habit.dart';
import 'package:habit_tracker/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserProvider extends ChangeNotifier {
  User _user = User.empty();
  List<User> users = [];
  bool isDark = false;

  final SharedPreferences prefs;

  UserProvider(this.prefs) {

    String? initialUser = prefs.getString("currentUser");
    String? data = prefs.getString("data");
    bool? themeProp = prefs.getBool("darkTheme");
    print(initialUser);

    if (themeProp != null) {
      isDark = themeProp;
    }
    if (data != null && data != "") {
      users = (jsonDecode(data) as List)
          .map((e) => User.fromJson(jsonEncode(e).toString()))
          .toList();
    }
    if (initialUser != null && initialUser != "") {
      var currentUserData = jsonDecode(initialUser);
      _user = users[currentUserData["index"]];
      _user.indexInArray = currentUserData["index"];
      print(currentUserData);
      print(_user);
    }

    // TODO check for this method if it is working
    computeDayCycleAndHighScore();

    notifyListeners();
  }

  User get user => _user;

  login(String name, String imagePath, bool isUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<User> newUsers = users;
    if (newUsers.indexWhere((element) => element.name == name) == -1) {
      var newUser = User(
          id: Uuid().v4(),
          name: name,
          imagePath: imagePath,
          isUrl: isUrl,
          noOfHabits: 0,
          streaks: 0,
          targetStreaks: 0,
          habits: [],
          isEmpty: false,
          indexInArray: users.length);

      await prefs.setString("currentUser",
          jsonEncode({"name": newUser.name, "index": users.length}));

      newUsers.add(newUser);
      _user = newUser;
      await saveData(newUsers);
      await computeDayCycleAndHighScore();
    }
  }

  contineSession(User newUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _user = newUser;
    await prefs.setString("currentUser",
        jsonEncode({"name": newUser.name, "index": newUser.indexInArray}));
    print(user.habits);
    notifyListeners();

    await computeDayCycleAndHighScore();
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("currentUser", "");
    print(_user.indexInArray);
    print(users[_user.indexInArray].name);
    print(users[_user.indexInArray].habits);

    _user = User.empty();
    notifyListeners();
  }

  addHabit(Habit habit) async {
    print(_user.indexInArray);
    // TODO done create scheduled notification awesome notification
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          wakeUpScreen: true,
          fullScreenIntent: true,
          id: habit.indexInArray, // -1 is replaced by a random number
          channelKey: 'basic_channel',
          title: habit.title,
          body: habit.description,
          bigPicture: habit.imagePath,
          largeIcon:
              'https://cdn.iconscout.com/icon/free/png-256/flutter-3628777-3030139.png?f=webp&w=256',
          //'asset://assets/images/balloons-in-sky.jpg',
          notificationLayout: NotificationLayout.BigPicture,
        ),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Open App'),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ],
        schedule: NotificationCalendar(
            allowWhileIdle: true,
            timeZone: localTimeZone,
            repeats: true,
            hour: habit.timeInDay[0] - 2,
            minute: habit.timeInDay[1],
            second: 0,
            millisecond: 0));

    habit.indexInArray = users[_user.indexInArray].habits.length;
    users[_user.indexInArray].habits.add(habit);
    users[_user.indexInArray].targetStreaks += habit.targetStreak;
    _user = users[_user.indexInArray];
    await saveData(users);
    notifyListeners();
  }

  setHabitDone(Habit habit) async {
    if (!habit.doneToday && !habit.achieved) {
      users[_user.indexInArray].streaks++;
      users[_user.indexInArray].habits[habit.indexInArray].streak++;
      users[_user.indexInArray].habits[habit.indexInArray].doneToday = true;
      users[_user.indexInArray].habits[habit.indexInArray].lastDayDone =
          Habit.dateToList(DateTime.now());
      _user = users[_user.indexInArray];

      if (users[_user.indexInArray].habits[habit.indexInArray].streak ==
          users[_user.indexInArray].habits[habit.indexInArray].targetStreak) {
        users[_user.indexInArray].habits[habit.indexInArray].achieved = true;
        await AwesomeNotifications().cancel(habit.indexInArray);
      }
      setHighScore(habit);
      await saveData(users);
      notifyListeners();
    }
  }

  computeDayCycleAndHighScore() async {
    for (var user in users) {
      for (var habit in user.habits) {
        DateTime now = DateTime.now();
        if (!habit.achieved) {
          if (!habit.doneToday) {
            if (habit.lastDayDone[2] == now.year) {
              if (habit.lastDayDone[1] == now.month) {
                if (habit.lastDayDone[0] == now.day) {
                  setHighScore(habit);
                  await saveData(users);
                } else if (habit.lastDayDone[0] + 1 == now.day) {
                  if (habit.timeInDay[0] < now.hour) {
                    setHighScore(habit);
                    await saveData(users);
                  } else if (habit.timeInDay[0] == now.hour) {
                    if (habit.timeInDay[1] < now.minute) {
                      setHighScore(habit);
                      await saveData(users);
                    } else {
                      await loseStreak(habit);
                    }
                  } else {
                    await loseStreak(habit);
                  }
                }
              } else {
                await loseStreak(habit);
              }
            } else {
              await loseStreak(habit);
            }
          } else {
            if ((habit.lastDayDone[2] == now.year) &&
                (habit.lastDayDone[1] == now.month) &&
                ((habit.lastDayDone[0] + 1) == now.day)) {
              users[user.indexInArray].habits[habit.indexInArray].doneToday =
                  false;
              setHighScore(habit);
              await saveData(users);
            }
          }
        } else {
          setHighScore(habit);
          await saveData(users);
        }
      }
    }
  }

  setHighScore(Habit habit) {
    var streak = users[user.indexInArray].habits[habit.indexInArray].streak;
    var highScore =
        users[user.indexInArray].habits[habit.indexInArray].highScore;

    if (streak > highScore) {
      users[user.indexInArray].habits[habit.indexInArray].highScore =
          users[user.indexInArray].habits[habit.indexInArray].streak;
    }
  }

  loseStreak(Habit habit) async {
    setHighScore(habit);
    users[_user.indexInArray].streaks -=
        users[user.indexInArray].habits[habit.indexInArray].streak;
    users[user.indexInArray].habits[habit.indexInArray].streak = 0;
    await saveData(users);
  }

  deleteHabit(Habit habit) async {
    users[user.indexInArray].habits.remove(habit);
    users[user.indexInArray].targetStreaks -= habit.targetStreak;
    _user = users[user.indexInArray];
    await AwesomeNotifications().cancel(habit.indexInArray);
    await saveData(users);
  }

  deleteUser(User user) async {
    users.remove(users[user.indexInArray]);
    await saveData(users);
  }

  saveData(userDataArr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = userDataArr
        .map((e) => jsonEncode(e.toJson()).toString())
        .toList()
        .toString();
    users = userDataArr;
    await prefs.setString("data", data);
    notifyListeners();
    print(data);
  }

  clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _user = User.empty();
    users = [];
    await prefs.setString("currentUser", "");
    await prefs.setString("data", "");
    notifyListeners();
  }

  toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkTheme", !(isDark));
    isDark = !(isDark);
    notifyListeners();
  }

  editUsersImage(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _user.imagePath = imagePath;
    users[_user.indexInArray].imagePath = imagePath;
    saveData(users);
  }
}
