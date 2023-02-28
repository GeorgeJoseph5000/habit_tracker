import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:habit_tracker/model/user.dart';
import 'package:habit_tracker/pages/home.dart';
import 'package:habit_tracker/ui/ui_shortcuts.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';


class Profile extends StatefulWidget {
  User user;
  bool showOptions = false;
  Profile(this.user, {super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var uploadImageForm  = UploadImage();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
      ),
      body: ListView(
        children: [
          /* Image */
          Container(
            height: 200,
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(widget.user.imagePath),
                  fit: BoxFit.cover),
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
                          widget.user.imagePath,
                          height: 150,
                          width: 150,
                        ),
                      )),
                    )),
              ),
            ),
          ),
          
          /* Text Numbers of Streaks */
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("No of Habits:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      user.noOfHabits.toString(),
                      textScaleFactor: 3,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Total Streaks:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      user.streaks.toString(),
                      textScaleFactor: 3,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Target Streaks:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      user.targetStreaks.toString(),
                      textScaleFactor: 3,
                    ),
                  ],
                ),
              ],
            ),
          ),
          /* Edit and Logout Buttons */
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        widget.showOptions = !widget.showOptions;
                      });
                    },
                    icon: Icon(Icons.edit),
                    label: Text("Edit")),
                ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      userProvider.logout();
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.logout),
                    label: Text("Logout")),
              ],
            ),
          ),
          /* Upload Form */
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: widget.showOptions
                  ? Column(
                      children: [uploadImageForm,
                      ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              if(uploadImageForm.urlController.text.isNotEmpty && uploadImageForm.isValidUrl){
                                userProvider.editUsersImage(uploadImageForm.urlController.text);
                              }
                            });
                          },
                          icon: Icon(Icons.save),
                          label: Text("Save")),
                          ],
                    )
                  : Text(""),
            ),
          )
        ],
      ),
    );
  }
}
