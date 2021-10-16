import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';

class PendingPaymentModel {
  String tx_reference;
  String identifier;
  String payment_reference;
  int status;
  DateTime datetime;
  String payment_method;

  PendingPaymentModel({
    @required this.tx_reference,
    @required this.identifier,
    @required this.payment_reference,
    @required this.status,
    @required this.datetime,
    @required this.payment_method
  });

  static PendingPaymentModel fromJson(Map<String, dynamic> json) {
    var result = PendingPaymentModel(
        tx_reference: json['tx_reference'],
        identifier: json['identifier'],
        payment_reference: json['payment_reference'] == null ? "117" : json['payment_reference'],
        status: json['status'],
        datetime: json['datetime'] == null ? null : DateTime.tryParse(json['datetime']),
        payment_method: json['payment_method']
    );
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      "tx_reference": this.tx_reference,
      "identifier": this.identifier,
      "payment_reference": this.payment_reference,
      "status": this.status,
      "datetime": this.datetime,
      "payment_method": EnumToString.convertToString(this.payment_method)
    };
  }
}