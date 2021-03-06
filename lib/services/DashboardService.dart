import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/models/EPaymentMethod.dart';
import 'package:free_drive/models/payment/LoadModel.dart';
import 'package:free_drive/models/payment/PendingPaymentModel.dart';
import 'package:free_drive/utils/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/ExceptionService.dart';
import 'package:free_drive/services/ServiceLocator.dart';
import 'package:nanoid/async.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CoreService _coreService = getIt.get<CoreService>();
  ExceptionService _exceptionService = getIt.get<ExceptionService>();

  bool loadIsPending = false;

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

  Future<bool> cancelRide(String rideId) async {
    bool success = true;
    try {
      await this._firestore.collection(FCN_rides)
          .doc(rideId)
          .update({"rideState": "canceled"});
    } catch (e) {
      success = false;
      this._exceptionService.manageExCeption(e);
    }
    return success;
  }

  Future<void> loadWallet(
      {double amount,
      String phoneNumber,
      EPaymentMethod paymentMethod,
      String clientWalletId
      }) async {
    var url = Uri.parse('https://paygateglobal.com/api/v1/pay');
    var newLoadId = await nanoid();
    var response = await http.post(url, body: {
      "auth_token": PAYGATE_API_TOKEN,
      "phone_number": phoneNumber,
      "amount": amount.toString(),
      "description": "Wallet load",
      "identifier": newLoadId,
      "network": EnumToString.convertToString(paymentMethod)
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if(response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      switch(jsonResponse['status']) {
        case 0:
          Utils.showDialogBox("Etat Transaction", "Transaction enregistr??e. Vous serez invit??s ?? confirmer.");
          var load = LoadModel(
            id: newLoadId,
            clientId: clientWalletId,
            amount: amount,
            loadStatus: EWalletLoadStatus.pending,
            loadDatetime: DateTime.now(),
            completedAt: null,
            txRef: jsonResponse['tx_reference'].toString(),
            paymentMethod: paymentMethod,
            phoneNumber: phoneNumber
          );
          try {
           var reference = jsonResponse['tx_reference'];
           // store pending load transaction
           await this._firestore.collection(FCN_wallet_loads).doc("$reference").set(load.toJson());
          } catch (e) {
            rethrow;
          }
          break;
        case 2:
          Utils.showErrorDialog("Echec Transaction", "Jeton d'authentification invalide.");
          break;
        case 4:
          Utils.showErrorDialog("Echec Transaction", "Param??tres invalides.");
          break;
        case 6:
          Utils.showErrorDialog("Echec Transaction", "Doublons d??tect??es. Une transaction avec le m??me identifiant existe d??ja. Veuillez reessayer...");
          break;
      }
    }
  }

  Future<PendingPaymentModel> loadPendingPayment(String txReference) async {
    Uri url = Uri.tryParse("https://paygateglobal.com/api/v1/status");
    try {
      var requestResponse = await http.post(
          url,
          body: {"auth_token": PAYGATE_API_TOKEN, "tx_reference": txReference}
      );
      if(requestResponse.statusCode == 200) {
        Map<String, dynamic> jsonPendingPayment = jsonDecode(requestResponse.body);
        PendingPaymentModel pendingPayment = PendingPaymentModel.fromJson(jsonPendingPayment);
        return pendingPayment;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<String>> getPendingPaymentReferences() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await this._firestore.collection(FCN_wallet_loads)
        .where("clientWalletId", isEqualTo: this._firebaseAuth.currentUser.uid)
        .get();

    List<LoadModel> loads = querySnapshot.docs.map((e) => LoadModel.fromJson(e.data())).toList();
    List<String> loadRefs = loads.map((e) => e.txRef).toList();
    return loadRefs;
  }
  
  Future<bool> confirmPayment(PendingPaymentModel pendingPaymentModel) async {
    var querySnapshot = await _firestore.collection((FCN_wallet_loads)).where("tx_ref", isEqualTo: pendingPaymentModel.tx_reference).get();
    double amount = querySnapshot.docs.first.data()['amount'];
    EWalletLoadStatus walletLoadStatus = EnumToString.fromString([EWalletLoadStatus.done, EWalletLoadStatus.pending], querySnapshot.docs.first.data()['loadStatus']);

    if(walletLoadStatus == EWalletLoadStatus.pending) {
      await this._firestore.collection(FCN_wallet_loads).doc(pendingPaymentModel.tx_reference)
          .update({
        "loadStatus": EnumToString.convertToString(EWalletLoadStatus.done),
        "completedAt": DateTime.now()
      });

      this._firestore.collection(FCN_wallets)
          .doc(this._firebaseAuth.currentUser.uid)
          .update({"balance": FieldValue.increment(amount)});
      return true;
    }

    return false;

  }
  
  Future<void> loadBalance() async {
    var snapshots = this._firestore.collection(FCN_wallets)
        .where("id", isEqualTo: this._firebaseAuth.currentUser.uid)
        .snapshots();
    snapshots.listen((QuerySnapshot<Map<String, dynamic>> event) { 
      this._coreService.userDashboardState.balance = double.tryParse(event.docs.first.data()['balance'].toString());
    });
  }

}
