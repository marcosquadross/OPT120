import 'package:flutter/material.dart';
import 'package:opt120/pages/home.dart';
import 'package:opt120/pages/login.dart';
import 'package:opt120/pages/activities_list.dart';
import 'package:opt120/pages/users_list.dart';
import 'package:opt120/pages/user_register.dart';
import 'package:opt120/pages/activity_register.dart';
import 'package:opt120/pages/user_activity_register.dart';
import 'package:opt120/pages/user_activity_list.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        // '/': (context) => const ActivityScreen(),
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
        '/userList': (context) => const UserScreen(),
        '/userRegister': (context) => const UserRegisterScreen(),
        '/activityRegister': (context) => const ActivityRegisterScreen(),
        '/activityList': (context) => const ActivityScreen(),
        '/userActivityList': (context) => const UserActivityScreen(),
        '/userActivityRegister': (context) =>
            const UserActivityRegisterScreen(),
      },
    );
  }
}

void main() => runApp(const MyApp());
