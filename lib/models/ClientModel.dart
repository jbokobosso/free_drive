import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/payment/Wallet.dart';

import 'UserModel.dart';

class ClientModel extends UserModel {

  ClientModel(String displayName, String email, String phoneNumber, String address) : super(displayName, email, phoneNumber, address);

  @override
  toMap({EUserType userType}) {
    return {
    "displayName": this.displayName,
    "email": this.email,
    "phoneNumber": this.phoneNumber,
    "address": this.address,
    "userType": userType == EUserType.client ? "client" : userType == EUserType.driver ? "driver" : null
    };
  }

}