import 'package:flutter/material.dart';
import 'package:habit_tracker/model/habit.dart';
import 'package:habit_tracker/pages/more_info.dart';
import 'package:habit_tracker/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HabitEntery extends StatefulWidget {
  bool showOptions = false;
  Habit habit;
  HabitEntery(this.habit, {super.key});

  @override
  State<HabitEntery> createState() => _HabitEnteryState();
}

class _HabitEnteryState extends State<HabitEntery> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Card(
      child: Column(children: [
        Column(
          children: [
            InkWell(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MoreInfo(widget.habit)))
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: widget.habit.isUrl
                            ? Image.network(
                                widget.habit.imagePath,
                                width: 100,
                              )
                            : Text("")),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.habit.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(Habit.timeToString(Habit.listToTime(widget.habit.timeInDay), context)),
                      Text(
                        "Date started:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(Habit.dateToString(Habit.listToDate(widget.habit.dateCreated))),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("Streak:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          widget.habit.streak.toString(),
                          textScaleFactor: 3,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await setHabitDone(widget.habit
                            , userProvider);
                          },
                          child: Icon(Icons.check, color: widget.habit.doneToday ? Colors.white : Colors.blue),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            side: BorderSide(color: widget.habit.doneToday ? Colors.blue : Colors.white, width: 2),
                            backgroundColor: widget.habit.doneToday ? Colors.blue : Colors.white, 
                            foregroundColor: widget.habit.doneToday ? Colors.white : Colors.blue, 
                          ),
                        ),
                        IconButton(
                            onPressed: () => {
                                  setState(() => {
                                        widget.showOptions = !widget.showOptions
                                      })
                                },
                            icon: Icon(Icons.arrow_drop_down))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: widget.showOptions
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MoreInfo(widget.habit)));
                            },
                            icon: Icon(Icons.edit),
                            color: Colors.blue,
                          ),
                          Column(
                            children: [
                              Text("Target Streak: " +
                                  widget.habit.targetStreak.toString()),
                              Text("High Score: " +
                                  widget.habit.highScore.toString()),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              userProvider.deleteHabit(widget.habit);
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ],
                      )
                    : Text(""),
              ),
            )
          ],
        ),
        LinearProgressIndicator(value: widget.habit.streak/widget.habit.targetStreak)
      ]),
    );
  }
}


setHabitDone(Habit habit, UserProvider userProvider) async{
  await userProvider.setHabitDone(habit);
}