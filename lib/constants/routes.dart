import 'package:flutter/material.dart';
import 'package:free_drive/ui/pages/auth/AuthPage.dart';

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder> {
  '/auth': (BuildContext context) => AuthPage(),
};