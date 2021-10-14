import 'package:flutter/foundation.dart';
import 'package:free_drive/models/ClientModel.dart';
import 'package:free_drive/models/DriverModel.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/payment/Wallet.dart';

abstract class UserModel {
  String id;
  String email;
  String password;
  String displayName;
  String phoneNumber;
  String address;
  EUserType userType;
  Wallet wallet;

  UserModel(this.displayName, this.email,this.phoneNumber, this.address, this.wallet, {this.password, this.id, this.userType});

  toMap({@required EUserType userType});

  static ClientModel clientFromMap(Map<String, dynamic> jsonClient) {
    return jsonClient == null ? null : new ClientModel(
      jsonClient["displayName"],
      jsonClient["email"],
      jsonClient["phoneNumber"],
      jsonClient["address"],
      Wallet.fromJson(jsonClient["wallet"])
    );
  }

  static DriverModel driverFromMap(Map<String, dynamic> jsonDriver) {
    var driverObject = new DriverModel(
        jsonDriver["displayName"],
        jsonDriver["email"],
        jsonDriver["phoneNumber"],
        jsonDriver["address"],
        Wallet.fromJson(jsonDriver["wallet"]),
        jsonDriver["isActive"],
    );
    return driverObject;
  }

}