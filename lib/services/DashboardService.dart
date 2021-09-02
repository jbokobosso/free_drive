import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/models/RideModel.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/GetIt.dart';

class DashboardService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  CoreService _coreService = getIt.get<CoreService>();

  Future<RideModel> getActiveRide() async {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await  _firebase.collection(FCN_rides)
          .where("clientEmail", isEqualTo: this._firebaseAuth.currentUser.email)
          .where("timeEnded", isNull: true)
          .get();
      RideModel ride = RideModel.fromJSON(querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      return ride;
  }

  Future<bool> activeRideExists() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await  _firebase.collection(FCN_rides)
        .where("clientEmail", isEqualTo: this._firebaseAuth.currentUser.email)
        .where("timeEnded", isNull: true)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

}
