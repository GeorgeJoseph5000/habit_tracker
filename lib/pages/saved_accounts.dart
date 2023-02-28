import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/home.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../ui/ui_shortcuts.dart';

class SelectAccount extends StatelessWidget {
  const SelectAccount({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DynamicHeightGridView(
            itemCount: userProvider.users.length,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            builder: (ctx, index) {
              return Container(
                width: 200,
                height: 250,
                decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /* Image */
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: Image.network(
                          userProvider.users[index].imagePath,
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    
                    /* Name */
                    Text(userProvider.users[index].name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 5,
                    ),
                    /* Text Numbers of Streaks */
                    Text(
                        "Habits: ${userProvider.users[index].noOfHabits}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 115, 115, 115),
                        )),
                    Text(
                        "Streaks: ${userProvider.users[index].streaks}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 115, 115, 115),
                        )),
                    Text(
                        "Target Streaks: ${userProvider.users[index].targetStreaks}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 115, 115, 115),
                        )),
                    /* Buttons Continue or Delete */
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text(""),
                            onPressed: () {
                              userProvider
                                .contineSession(userProvider.users[index]);
                            },
                          ),
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.delete),
                            label: const Text(""),
                            onPressed: () {
                              userProvider
                                .deleteUser(userProvider.users[index]);
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
