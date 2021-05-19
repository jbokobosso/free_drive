import 'package:flutter/material.dart';
import 'package:free_drive/ui/pages/auth/SignupPage.dart';
import 'package:free_drive/ui/pages/auth/ValidationPage.dart';
import 'package:free_drive/ui/pages/intro/IntroPage.dart';

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder> {
  '/auth': (BuildContext context) => SignupPage(),
  '/intro': (BuildContext context) => IntroPage(),
  '/validation': (BuildContext context) => ValidationPage(),
};