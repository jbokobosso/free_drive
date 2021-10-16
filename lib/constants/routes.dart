import 'package:flutter/material.dart';
import 'package:free_drive/ui/pages/ask_driver/UploadDriverLicencePage.dart';
import 'package:free_drive/ui/pages/auth/LoginPage.dart';
import 'package:free_drive/ui/pages/auth/RecoverPasswordPage.dart';
import 'package:free_drive/ui/pages/auth/SignupPage.dart';
import 'package:free_drive/ui/pages/auth/ValidationPage.dart';
import 'package:free_drive/ui/pages/ask_driver/AdkDriverPage.dart';
import 'package:free_drive/ui/pages/ask_driver/ContactDriverPage.dart';
import 'package:free_drive/ui/pages/dashboard/DriverDashboardPage.dart';
import 'package:free_drive/ui/pages/dashboard/PendingPayments.dart';
import 'package:free_drive/ui/pages/dashboard/ProfilePage.dart';
import 'package:free_drive/ui/pages/dashboard/RideDetailsPage.dart';
import 'package:free_drive/ui/pages/dashboard/UserDashboardPage.dart';
import 'package:free_drive/ui/pages/ask_driver/YourDriverPage.dart';
import 'package:free_drive/ui/pages/intro/IntroPage.dart';
import 'package:free_drive/ui/pages/notifications/NotificationsPage.dart';
import 'package:free_drive/ui/pages/startup_view.dart';
import 'package:free_drive/ui/shared/Loading.dart';
import 'package:free_drive/ui/shared/Starter.dart';

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder> {
  '/intro': (BuildContext context) => IntroPage(),
  '/loading': (BuildContext context) => Loading(),
  '/signup': (BuildContext context) => SignupPage(),
  '/login': (BuildContext context) => LoginPage(),
  '/validation': (BuildContext context) => ValidationPage(),
  '/dashboard': (BuildContext context) => UserDashboardPage(),
  '/driverDashboard': (BuildContext context) => DriverDashboardPage(),
  '/askDriver': (BuildContext context) => AskDriverPage(),
  '/yourDriver': (BuildContext context) => YourDriverPage(),
  '/contactDriver': (BuildContext context) => ContactDriverPage(),
  '/starter': (BuildContext context) => Starter(),
  '/uploadDriverLicence': (BuildContext context) => UploadDriverLicencePage(),
  '/notifs': (BuildContext context) => NotificationsPage(),
  '/rideDetails': (BuildContext context) => RideDetailsPage(),
  '/profile': (BuildContext context) => ProfilePage(),
  '/startup': (BuildContext context) => StartupView(),
  '/recoverPassword': (BuildContext context) => RecoverPasswordPage(),
  '/pendingPayments': (BuildContext context) => PendingPayment(),
};