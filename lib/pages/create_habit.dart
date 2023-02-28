import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:habit_tracker/model/habit.dart';
import 'package:habit_tracker/model/user.dart';
import 'package:habit_tracker/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../ui/ui_shortcuts.dart';


class CreateHabit extends StatefulWidget {
  CreateHabit({super.key});
  int segmentedControlGroupValue = 0;
  TimeOfDay timeInDay = TimeOfDay(hour: 0, minute: 0);

  @override
  State<CreateHabit> createState() => _CreateHabitState();
}

var titleController = TextEditingController();
var descriptionController = TextEditingController();
var targetStreakController = TextEditingController();
var urlController = TextEditingController();


class _CreateHabitState extends State<CreateHabit> {
  var myTabs = <int, Widget>{0: Text("URL"), 1: Text("File")};
  var uploadForm = UploadImage();

  

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Habit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            /* Textformfields */
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Enter Habit Title',
              ),
            ),
            TextFormField(
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: 'Enter Description',
              ),
              maxLines: 4,
            ),
            TextFormField(
              controller: targetStreakController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                TextInputFormatter.withFunction(
                  (oldValue, newValue) => newValue.copyWith(
                    text: newValue.text.replaceAll('.', ','),
                  ),
                ),
              ],
              decoration: const InputDecoration(
                labelText: 'Enter Target Streak',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            /* Time Picker */
            ElevatedButton(
                onPressed: () async {
                  TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: 0, minute: 0),
                  );
                  setState(() {
                    if(newTime != null){
                      widget.timeInDay = newTime;
                    }
                  });
                  print(newTime);
                },
                child: Text("Choose Time")),
            Center(child: Text(widget.timeInDay.toString() == "null" ? "" : widget.timeInDay.format(context))),
            const Text(
              "Image",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            uploadForm,
            const SizedBox(
              height: 20,
            ),
            /* Submit Button */
            ElevatedButton(onPressed: () {
              if(titleController.text != "" && targetStreakController.text != "" && uploadForm.urlController.text != "" && descriptionController.text != "" && uploadForm.isValidUrl){

                userProvider.addHabit(Habit(id: Uuid().v4(), title: titleController.text, dateCreated: Habit.dateToList(DateTime.now()), timeInDay: Habit.timeToList(widget.timeInDay), streak: 0, highScore: 0, targetStreak: int.parse(targetStreakController.text), imagePath: uploadForm.urlController.text, isUrl: uploadForm.isURL, doneToday: false, lastDayDone: Habit.dateToList(DateTime.now()), description: descriptionController.text, indexInArray: userProvider.user.habits.length, achieved: false));
                
                titleController.clear();
                targetStreakController.clear();
                descriptionController.clear();
                setState(() {
                  widget.timeInDay = TimeOfDay(hour: 0, minute: 0);
                });

                Navigator.pop(context);
              }else{
                showSnackBar(context, "Inputs Invalid");
              }
            }, child: Text("Add"))
          ],
        ),
      ),
    );
  }
}
