import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/UserModel.dart';

class DriverModel extends UserModel {

  bool isActive;

  DriverModel(String displayName, String email, String phoneNumber, String address, this.isActive) : super(displayName, email, phoneNumber, address);

  @override
  toMap({EUserType userType}) {
    return {
      "displayName": this.displayName,
      "email": this.email,
      "phoneNumber": this.phoneNumber,
      "address": this.address,
      "isActive": this.isActive = false,
      "userType": userType == EUserType.client ? "client" : userType == EUserType.driver ? "driver" : null,
    };
  }

}