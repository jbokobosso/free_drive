import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/GetIt.dart';

class ContactDriverService {
  CoreService _coreService = getIt.get<CoreService>();

  newRide() {
    _coreService.userDashboardState.activeRideExists = true;
  }

  Future<bool> callDriver() async {
    const number = '+22899885825'; //set the number here
    bool callSucceded = await FlutterPhoneDirectCaller.callNumber(number);
    return callSucceded;
  }

  bool textDriver() {
    navigatorKey.currentState.pop();
    return true;
  }
}