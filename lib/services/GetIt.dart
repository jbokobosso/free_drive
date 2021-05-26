import 'package:free_drive/services/CoreService.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerLazySingleton(() => CoreService());
}