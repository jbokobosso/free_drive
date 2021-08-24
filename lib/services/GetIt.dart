import 'package:free_drive/services/AskDriverService.dart';
import 'package:free_drive/services/AuthService.dart';
import 'package:free_drive/services/ContactDriverService.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/IAuthService.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerLazySingleton(() => CoreService());
  getIt.registerLazySingleton(() => ContactDriverService());
  getIt.registerSingleton<IAuthService>(AuthService());
  getIt.registerLazySingleton(() => AskDriverService());
}