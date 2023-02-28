import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:habit_tracker/model/user.dart';
import 'package:habit_tracker/pages/profile.dart';
import 'package:habit_tracker/ui/styles.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../ui/habit_entry.dart';
import '../model/habit.dart';
import './create_habit.dart';

var habit = Habit.empty();

var user = User.empty();

class Home extends StatefulWidget {
  Home({super.key});
  String dropdownvalue = "Sort by Time";
  String ascendingOrDescending = "Ascending";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    user = userProvider.user;
    List<Habit> habits = userProvider.user.habits;

    if (widget.dropdownvalue == "Sort by Title") {
      habits.sort((a, b) => a.title.compareTo(b.title));
    } else if (widget.dropdownvalue == "Sort by Time") {
      habits.sort((a, b) => Habit.listToDate(a.dateCreated)
          .compareTo(Habit.listToDate(b.dateCreated)));
    } else {
      habits.sort((a, b) => a.streak.compareTo(b.streak));
    }

    widget.ascendingOrDescending == "Descending"
        ? habits = habits.reversed.toList()
        : print("Ascending");

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            /* Drawer */
            DrawerHeader(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(user.imagePath), fit: BoxFit.cover),
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                      alignment: Alignment.center,
                      color: Colors.grey.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: Image.network(
                            user.imagePath,
                            height: 100,
                            width: 100,
                          ),
                        )),
                      )),
                ),
              ),
            ),
            Center(
                child: Text(
              user.name,
              style: TextStyle(fontSize: 30),
            )),
            /* List Tiles */
            ListTile(
              title: RichText(
                  text: TextSpan(children: [
                WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(Icons.account_box),
                  ),
                ),
                TextSpan(
                    text: "Profile",
                    style: TextStyle(
                        color: Styles.themeData(userProvider.isDark, context)
                            .primaryColor))
              ])),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Profile(user)));
              },
            ),
            ListTile(
              title: RichText(
                  text: TextSpan(children: [
                WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(Icons.logout),
                  ),
                ),
                TextSpan(
                    text: "Logout",
                    style: TextStyle(
                        color: Styles.themeData(userProvider.isDark, context)
                            .primaryColor))
              ])),
              onTap: () async {
                await userProvider.logout();
              },
            ),
            ListTile(
              title: RichText(
                  text: TextSpan(children: [
                WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(userProvider.isDark
                        ? Icons.light_mode
                        : Icons.dark_mode),
                  ),
                ),
                TextSpan(
                    text: userProvider.isDark ? "Light Theme" : "Dark Theme",
                    style: TextStyle(
                        color: Styles.themeData(userProvider.isDark, context)
                            .primaryColor))
              ])),
              onTap: () {
                userProvider.toggleTheme();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Habit Tracker"),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /* DropdownButtons */
                    DropdownButton(
                        items: [
                          "Sort by Title",
                          "Sort by Time",
                          "Sort by Streak"
                        ]
                            .map((value) => DropdownMenuItem(
                                value: value,
                                child: RichText(
                                    text: TextSpan(children: [
                                  const WidgetSpan(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.0),
                                      child: Icon(Icons.sort),
                                    ),
                                  ),
                                  TextSpan(
                                      text: value,
                                      style: TextStyle(
                                          color: Styles.themeData(
                                                  userProvider.isDark, context)
                                              .primaryColor))
                                ]))))
                            .toList(),
                        onChanged: (String? value) => {
                              setState(() {
                                widget.dropdownvalue = value!;
                              })
                            },
                        value: widget.dropdownvalue),
                    DropdownButton(
                        items: [
                          "Ascending",
                          "Descending",
                        ]
                            .map((value) => DropdownMenuItem(
                                value: value,
                                child: RichText(
                                    text: TextSpan(children: [
                                  const WidgetSpan(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.0),
                                      child: Icon(Icons.sort),
                                    ),
                                  ),
                                  TextSpan(
                                      text: value,
                                      style: TextStyle(
                                          color: Styles.themeData(
                                                  userProvider.isDark, context)
                                              .primaryColor))
                                ]))))
                            .toList(),
                        onChanged: (String? value) => {
                              setState(() {
                                widget.ascendingOrDescending = value!;
                              })
                            },
                        value: widget.ascendingOrDescending)
                  ],
                ),
              ),
              /* Habits */
              Column(
                children: habits.map((e) => HabitEntery(e)).toList(),
              ),
              /*const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Done Today",
                  textScaleFactor: 2,
                ),
              ),*/
            ],
          ),
        ],
      ),
      /* addButton */
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CreateHabit()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
