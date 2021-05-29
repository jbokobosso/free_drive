import 'package:flutter/material.dart';
import 'package:free_drive/ui/pages/ask_driver/UploadDriverLicencePage.dart';
import 'package:free_drive/ui/pages/auth/LoginPage.dart';
import 'package:free_drive/ui/pages/auth/SignupPage.dart';
import 'package:free_drive/ui/pages/auth/ValidationPage.dart';
import 'package:free_drive/ui/pages/ask_driver/AdkDriverPage.dart';
import 'package:free_drive/ui/pages/ask_driver/ContactDriverPage.dart';
import 'package:free_drive/ui/pages/dashboard/DriverDashboardPage.dart';
import 'package:free_drive/ui/pages/dashboard/UserDashboardPage.dart';
import 'package:free_drive/ui/pages/ask_driver/YourDriverPage.dart';
import 'package:free_drive/ui/pages/intro/IntroPage.dart';
import 'package:free_drive/ui/pages/notifications/NotificationsPage.dart';
import 'package:free_drive/ui/shared/NavigationStarter.dart';

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder> {
  '/signup': (BuildContext context) => SignupPage(),
  '/intro': (BuildContext context) => IntroPage(),
  '/validation': (BuildContext context) => ValidationPage(),
  '/login': (BuildContext context) => LoginPage(),
  '/dashboard': (BuildContext context) => UserDashboardPage(),
  '/driverDashboard': (BuildContext context) => DriverDashboardPage(),
  '/askDriver': (BuildContext context) => AskDriverPage(),
  '/yourDriver': (BuildContext context) => YourDriverPage(),
  '/contactDriver': (BuildContext context) => ContactDriverPage(),
  '/navigationStarter': (BuildContext context) => NavigationStarter(),
  '/uploadDriverLicence': (BuildContext context) => UploadDriverLicencePage(),
  '/notifs': (BuildContext context) => NotificationsPage(),
};