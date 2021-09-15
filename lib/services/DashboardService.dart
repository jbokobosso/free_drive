import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/GetIt.dart';

class DashboardService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  CoreService _coreService = getIt.get<CoreService>();

  Stream<QuerySnapshot<Map<String, dynamic>>> getActiveRide() {
    Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshotStream = _firebase.collection(FCN_rides)
          .where("clientEmail", isEqualTo: this._firebaseAuth.currentUser.email)
          .where("timeEnded", isNull: true)
          .snapshots();
      return querySnapshotStream;
  }

  Future<bool> userActiveRideExists() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await  _firebase.collection(FCN_rides)
        .where("clientEmail", isEqualTo: this._firebaseAuth.currentUser.email)
        .where("timeEnded", isNull: true)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDriverActiveRide() {
    Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshotStream = _firebase.collection(FCN_rides)
        .where("timeEnded", isNull: true)
        .firestore.collection("driver")
        .where("email", isEqualTo: this._firebaseAuth.currentUser.email)
        .snapshots();
    return querySnapshotStream;
  }

  Future<bool> driverActiveRideExists() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await  _firebase.collection(FCN_rides)
        .where("timeEnded", isNull: true)
        .where("driver", )
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

}
