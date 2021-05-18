import 'package:flutter/material.dart';
import 'package:free_drive/constants/routes.dart';


final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Free Drive',
      theme: ThemeData(
        primarySwatch: Theme.of(context).primaryColor,
        primaryColor: Color(0xffE67925),
        accentColor: Color(0xffFFF4EB)
      ),
      initialRoute: "/auth",
      routes: routes,
      navigatorKey: navigatorKey,
    );
  }
}
