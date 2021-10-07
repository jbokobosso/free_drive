import 'package:free_drive/services/AskDriverService.dart';
import 'package:free_drive/services/AuthService.dart';
import 'package:free_drive/services/ContactDriverService.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/DashboardService.dart';
import 'package:free_drive/services/ExceptionService.dart';
import 'package:free_drive/services/ProfileService.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerLazySingleton(() => CoreService());
  getIt.registerLazySingleton(() => ContactDriverService());
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerLazySingleton(() => AskDriverService());
  getIt.registerLazySingleton(() => ExceptionService());
  getIt.registerLazySingleton(() => DashboardService());
  getIt.registerLazySingleton(() => ProfileService());
}