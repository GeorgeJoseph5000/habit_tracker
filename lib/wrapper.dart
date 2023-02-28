import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/auth.dart';
import 'package:habit_tracker/providers/user_provider.dart';
import 'package:habit_tracker/ui/styles.dart';
import 'package:provider/provider.dart';
import './pages/home.dart';

class Wrapper extends StatefulWidget {
  Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return MaterialApp(
        theme: Styles.themeData(userProvider.isDark, context),
        title: 'Habit Tracker',
        home: userProvider.user.isEmpty ? Auth() : Home());
  }
}
