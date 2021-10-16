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
          Utils.showDialogBox("Etat Transaction", "Transaction enregistrée. Vous serez invités à confirmer.");
          var load = LoadModel(
            id: newLoadId,
            clientId: clientWalletId,
            amount: amount,
            loadStatus: EWalletLoadStatus.pending,
            loadDatetime: DateTime.now(),
            completedAt: null,
            txRef: jsonResponse['tx_reference'].toString(),
            paymentMethod: paymentMethod,
            phoneNumber: null
          );
          try {
           var reference = jsonResponse['tx_reference'];
           // store pending load transaction
           await this._firestore.collection(FCN_wallet_loads).doc("$reference").set(load.toJson());
           // locally store pending generated transaction for above load
           await this.storeNewPendingPaymentReference(reference.toString());
          } catch (e) {
            rethrow;
          }
          break;
        case 2:
          Utils.showErrorDialog("Echec Transaction", "Jeton d'authentification invalide.");
          break;
        case 4:
          Utils.showErrorDialog("Echec Transaction", "Paramètres invalides.");
          break;
        case 6:
          Utils.showErrorDialog("Echec Transaction", "Doublons détectées. Une transaction avec le même identifiant existe déja. Veuillez reessayer...");
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

  Future<bool> storeNewPendingPaymentReference(String txReference) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> refs = [];
    refs.addAll(await getPendingPaymentReferences());
    refs.add(txReference);
    String dataToStore = jsonEncode(refs);
    return await prefs.setString(S_pendingPaymentReference, dataToStore);
  }

  Future<List<String>> getPendingPaymentReferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> refs = [];
    String storedRefs = prefs.getString(S_pendingPaymentReference);
    if(storedRefs == null)
      return []; // retourner un tableau vide s'il n'y a pas de réference
    List<String> tempList = [];
    List<dynamic> jsonData = jsonDecode(storedRefs);
    tempList.addAll(jsonData.map((e) => e.toString()));
    return tempList;
  }

}
