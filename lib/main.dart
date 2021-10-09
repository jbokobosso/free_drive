import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:free_drive/constants/routes.dart';
import 'package:free_drive/services/ServiceLocator.dart';
import 'package:free_drive/ui/pages/intro/IntroPage.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void selectNotification(String payload) async {
  if (payload != null) debugPrint('notification payload: $payload');
  navigatorKey.currentState.pushNamed('/intro', arguments: payload);
}

prepareLocalNotification() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your channel id', 'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, 'plain title', 'plain body', platformChannelSpecifics, payload: 'item x');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupServiceLocator();
  await prepareLocalNotification();
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
      initialRoute: "/startup",
      routes: routes,
      navigatorKey: navigatorKey,
    );
  }
}
