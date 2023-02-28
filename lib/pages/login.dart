import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dark_light_button/dark_light_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../ui/ui_shortcuts.dart';
import '../providers/notification_service.dart';

var nameController = TextEditingController();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var myTabs = <int, Widget>{0: Text("URL"), 1: Text("File")};
  var uploadImageForm = UploadImage();

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Habit Tracker",
              style: TextStyle(fontSize: 50),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your Name',
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(20), child: uploadImageForm),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 30,
              ),
            ),
            StyledButton("Continue →", () async {
              String localTimeZone =
                  await AwesomeNotifications().getLocalTimeZoneIdentifier();
              String utcTimeZone =
                  await AwesomeNotifications().getLocalTimeZoneIdentifier();

              /*AwesomeNotifications().createNotification(
                  content: NotificationContent(
                      id: 11,
                      channelKey: 'basic_channel',
                      title: 'Simple Notification',
                      body: 'Simple body',
                      actionType: ActionType.Default,
                      criticalAlert: true,
                      wakeUpScreen: true));*/

              // random number

              /*await AwesomeNotifications().createNotification(
                  content: NotificationContent(
                      wakeUpScreen: true,
                      fullScreenIntent: true,
                      id: 1, // -1 is replaced by a random number
                      channelKey: 'basic_channel',
                      title: "Huston! The eagle has landed!",
                      body:
                          "A small step for a man, but a giant leap to Flutter's community!",
                      bigPicture: 'https://picsum.photos/200',
                      largeIcon: 'https://picsum.photos/200',
                      //'asset://assets/images/balloons-in-sky.jpg',
                      notificationLayout: NotificationLayout.BigPicture,
                      payload: {
                        'notificationId': '1234567890'
                      }),
                  actionButtons: [
                    NotificationActionButton(
                        key: 'REDIRECT', label: 'Redirect'),
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
                      hour: 19,
                      minute: 29,
                      second: 0,
                      millisecond: 0));*/

              if (nameController.text != "") {
                if (uploadImageForm.isURL) {
                  if (uploadImageForm.urlController.text != "" &&
                      uploadImageForm.isValidUrl) {
                    userProvider.login(nameController.text,
                        uploadImageForm.urlController.text, true);
                    nameController.clear();
                    uploadImageForm.urlController.clear();
                  } else {
                    showSnackBar(context, "Invalid URL");
                  }
                }
              }
            }),
            SizedBox(height: 30),
            DarlightButton(
                type:Darlights.DarlightOne,
                onChange: (ThemeMode theme) {
                  userProvider.toggleTheme();
                },
                options: DarlightOneOption())
          ],
        ),
      ),
    );
  }
}
