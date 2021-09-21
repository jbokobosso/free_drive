import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/models/RideModel.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/ExceptionService.dart';
import 'package:free_drive/services/ServiceLocator.dart';

class DashboardService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CoreService _coreService = getIt.get<CoreService>();
  ExceptionService _exceptionService = getIt.get<ExceptionService>();

  Future<bool> userActiveRideExists() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await  _firestore.collection(FCN_rides)
        .where("clientEmail", isEqualTo: this._firebaseAuth.currentUser.email)
        .where("timeEnded", isNull: true)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<bool> driverActiveRideExists() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await  _firestore.collection(FCN_rides)
        .where("driverEmail", isEqualTo: this._firebaseAuth.currentUser.email)
        .where("timeEnded", isNull: true)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserActiveRide() {
    Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshotStream = _firestore.collection(FCN_rides)
          .where("clientEmail", isEqualTo: this._firebaseAuth.currentUser.email)
          .where("timeEnded", isNull: true)
          .snapshots();
      return querySnapshotStream;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDriverActiveRide() {
    Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshotStream = _firestore.collection(FCN_rides)
        .where("timeEnded", isNull: true)
        .where("driverEmail", isEqualTo: this._firebaseAuth.currentUser.email)
        .snapshots();
    return querySnapshotStream;
  }

  Future<bool> acceptRide(String rideId) async {
    bool success = true;
    try {
      await this._firestore.collection(FCN_rides)
          .doc(rideId)
          .update({"rideState": "accepted"});
    } catch (e) {
      success = false;
      this._exceptionService.manageExCeption(e);
    }
    return success;
  }

  Future<bool> startRide(String rideId) async {
    bool success = true;
    try {
      await this._firestore.collection(FCN_rides)
          .doc(rideId)
          .update({
            "rideState": "running",
            "timeStarted": DateTime.now()
          });
    } catch (e) {
      success = false;
      this._exceptionService.manageExCeption(e);
    }
    return success;
  }

  Future<bool> endRide(String rideId) async {
    bool success = true;
    try {
      await this._firestore.collection(FCN_rides)
          .doc(rideId)
          .update({"rideState": "done", "timeEnded": DateTime.now()});
    } catch (e) {
      success = false;
      this._exceptionService.manageExCeption(e);
    }
    return success;
  }

  Future<bool> extendRide(String rideId, DateTime newReturnDate) async {
    bool success = true;
    try {
      await this._firestore.collection(FCN_rides)
          .doc(rideId)
          .update({"returnDate": newReturnDate});
    } catch (e) {
      success = false;
      this._exceptionService.manageExCeption(e);
    }
    return success;
  }

}
