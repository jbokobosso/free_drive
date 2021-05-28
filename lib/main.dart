import 'package:flutter/material.dart';
import 'package:free_drive/constants/routes.dart';
import 'package:free_drive/services/GetIt.dart';


final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
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
        accentColor: Color(0xffFFF4EB),
        textTheme: TextTheme(
            headline1: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff7C7D7E),
              fontSize: 12.0
            )
        ),
      ),
      initialRoute: "/intro",
      routes: routes,
      navigatorKey: navigatorKey,
    );
  }
}
