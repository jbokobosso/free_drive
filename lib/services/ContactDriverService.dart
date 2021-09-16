import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/ServiceLocator.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDriverService {
  CoreService _coreService = getIt.get<CoreService>();

  Future<bool> callDriver(String phoneNumber) async {
    bool callSucceded = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    return callSucceded;
  }

  Future<bool> textDriver(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
          this._coreService.showErrorDialog("SMS", onError);
        });
    return true;
  }
}