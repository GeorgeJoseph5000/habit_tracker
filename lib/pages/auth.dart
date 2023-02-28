import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/saved_accounts.dart';

import 'login.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
    length: 2,
    child: Scaffold(
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        items: const [
          TabItem(icon: Icons.login, title: 'Login'),
          TabItem(icon: Icons.switch_account, title: 'Select Profile'),
        ],
      ),
      body: const TabBarView(children: [
        Login(),
        SelectAccount()
      ]),
    ),
  );
  }
}
