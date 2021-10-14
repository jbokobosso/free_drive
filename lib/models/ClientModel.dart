import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/payment/Wallet.dart';

import 'UserModel.dart';

class ClientModel extends UserModel {

  ClientModel(String displayName, String email, String phoneNumber, String address, Wallet wallet) : super(displayName, email, phoneNumber, address, wallet);

  @override
  toMap({EUserType userType}) {
    return {
    "displayName": this.displayName,
    "email": this.email,
    "phoneNumber": this.phoneNumber,
    "address": this.address,
    "wallet": this.wallet.toJson(),
    "userType": userType == EUserType.client ? "client" : userType == EUserType.driver ? "driver" : null
    };
  }

}