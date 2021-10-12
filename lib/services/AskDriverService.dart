import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/models/DriverModel.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/RideModel.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/ExceptionService.dart';
import 'package:free_drive/services/ServiceLocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AskDriverService {

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CoreService _coreService = getIt.get<CoreService>();
  ExceptionService _exceptionService = getIt.get<ExceptionService>();

  LatLng _pickedLocation;
  get pickedLocation => _pickedLocation;

  setPickedLocation(LatLng latLng) {
    _pickedLocation = latLng;
  }

  Future<bool> newRide(RideModel ride) async {
    bool result = false;
    try {
      DocumentReference newRide = await this.firestore.collection(FCN_rides).add(ride.toJSON());
      if(newRide != null)
        result = true;
      else
        result = false;
    } catch (e) {
      result = false;
      this._exceptionService.manageExCeption(e);
    }
    return result;
  }

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