import 'package:cloud_firestore/cloud_firestore.dart';

class Utils {

  static timestampToDateTime(Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  }

}