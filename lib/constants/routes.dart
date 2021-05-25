import 'package:flutter/material.dart';
import 'package:free_drive/ui/pages/auth/LoginPage.dart';
import 'package:free_drive/ui/pages/auth/SignupPage.dart';
import 'package:free_drive/ui/pages/auth/ValidationPage.dart';
import 'package:free_drive/ui/pages/dashboard/AdkDriverPage.dart';
import 'package:free_drive/ui/pages/dashboard/DashboardPage.dart';
import 'package:free_drive/ui/pages/intro/IntroPage.dart';

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder> {
  '/signup': (BuildContext context) => SignupPage(),
  '/intro': (BuildContext context) => IntroPage(),
  '/validation': (BuildContext context) => ValidationPage(),
  '/login': (BuildContext context) => LoginPage(),
  '/dashboard': (BuildContext context) => DashboardPage(),
  '/askDriver': (BuildContext context) => AskDriverPage(),
};