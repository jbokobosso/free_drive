import 'package:flutter/services.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/DashboardModel.dart';
import 'package:free_drive/models/RideModel.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/DashboardService.dart';
import 'package:free_drive/services/GetIt.dart';
import 'package:free_drive/services/IAuthService.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

class DashboardViewModel extends BaseViewModel {

  CoreService coreService = getIt.get<CoreService>();
  IAuthService authService = getIt.get<IAuthService>();
  DashboardService _dashboardService = getIt.get<DashboardService>();

  double get deviceWidth => this.coreService.deviceWidth;
  double get deviceHeight => this.coreService.deviceHeight;

  Artboard eyeArtboard;
  Artboard logoArtboard;
  RiveAnimationController eyeAnimationController;
  RiveAnimationController logoAnimationController;

  RideModel activeRide;
  RideModel pendingRide;

  initView() {
    this.initEyeAnimation();
    this.checkActiveRide();
  }

  initEyeAnimation() {
    rootBundle.load('assets/rive/close_open_eye.riv')
        .then(
          (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(eyeAnimationController = SimpleAnimation('close'));
        eyeArtboard = artboard;
        notifyListeners();
        eyeAnimationController.isActive = true;
        notifyListeners();
      },
    );
  }

  cancelActiveRide() {
    this.coreService.userDashboardState.activeRideExists = false;
    navigatorKey.currentState.pop();
    notifyListeners();
  }

  Future<void> checkActiveRide() async {
    setBusy(true);
    bool activeRideExists = await this._dashboardService.activeRideExists();
    if(activeRideExists) {
      this.activeRide = await this.loadActiveRide();
      var state = new UserDashboardModel(
          balance: 0,
          activeRideExists: activeRideExists,
          pendingRideExists: !activeRideExists,
          completedRidesCount: 0
      );
      this.coreService.userDashboardState = state;
      notifyListeners();
      setBusy(false);
    }
  }

  Future<RideModel> loadActiveRide() async {
    RideModel ride = await this._dashboardService.getActiveRide();
    return ride;
  }

}