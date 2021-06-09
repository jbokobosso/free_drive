import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:free_drive/constants/routes.dart';
import 'package:free_drive/services/GetIt.dart';
import 'package:free_drive/services/IAuthService.dart';

IAuthService _authService = getIt.get<IAuthService>();
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Future<String> _getStartupRoute() async {
  if(await _authService.checkIntroPassed() == true) {
    if(await _authService.checkUserLoggedLocally() == true)
      return '/starter';
    else
      return '/login';
  }
  else return '/intro';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var rst = _getStartupRoute();
    rst.then((value) {
      navigatorKey.currentState.pushNamedAndRemoveUntil(value, (route) => false);
    });
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
      initialRoute: "/loading",
      routes: routes,
      navigatorKey: navigatorKey,
    );
  }
}
