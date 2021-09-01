import 'package:free_drive/main.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/GetIt.dart';
import 'package:free_drive/services/IAuthService.dart';
import 'package:stacked/stacked.dart';

class StartupViewModel extends BaseViewModel {

  final IAuthService _authService = getIt<IAuthService>();
  final CoreService _coreService = getIt<CoreService>();

  Future handleStartupLogic() async {
    String route = "";
    if(await _authService.checkIntroPassed() == true) {
      if(await _authService.checkUserIsLogged() == true) {
        UserModel loggedUser = await _authService.getLoggedUser();
        if(loggedUser.userType == EUserType.client)  {
          route =  "/dashboard";
        } else if(loggedUser.userType == EUserType.driver) {
          _coreService.setDriverState(loggedUser);
          route = "/driverDashboard";
        } else throw "Locally logged user has no user type stored !!! Reinstall the app if in developpement";
      } else
        route = '/login';
    } else {
      route = '/intro';
    }
    navigatorKey.currentState.pushNamedAndRemoveUntil(route, (route) => false);
  }
}