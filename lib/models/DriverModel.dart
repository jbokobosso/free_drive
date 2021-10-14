import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/models/payment/Wallet.dart';

class DriverModel extends UserModel {

  bool isActive;

  DriverModel(String displayName, String email, String phoneNumber, String address, Wallet wallet, this.isActive,) : super(displayName, email, phoneNumber, address, wallet);

  @override
  toMap({EUserType userType}) {
    return {
      "displayName": this.displayName,
      "email": this.email,
      "phoneNumber": this.phoneNumber,
      "address": this.address,
      "wallet": this.wallet.toJson(),
      "isActive": this.isActive = false,
      "userType": userType == EUserType.client ? "client" : userType == EUserType.driver ? "driver" : null,
    };
  }

}