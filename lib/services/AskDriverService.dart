import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/models/DriverModel.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/GetIt.dart';

class AskDriverService {

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CoreService _coreService = getIt.get<CoreService>();

  Future<List<DriverModel>> loadDrivers() async {
    List<DriverModel> drivers = [];
    QuerySnapshot<Map<String, dynamic>> driversQuerySnap = await firestore.collection(FCN_drivers).get();
    driversQuerySnap.docs.forEach((element) {
      Map<String, dynamic> firebaseJsonData = element.data();
      DriverModel tempDriver = UserModel.driverFromMap(firebaseJsonData);
      tempDriver.userType = EUserType.driver;
      tempDriver.id = element.id;
      drivers.add(tempDriver);
    });
    return drivers;
  }
}