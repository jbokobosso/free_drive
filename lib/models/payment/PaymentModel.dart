import 'package:flutter/foundation.dart';
import 'package:free_drive/utils/Utils.dart';

class PaymentModel {
  String id;
  String clientWalletId;
  String driverWalletId;
  double amount;
  DateTime paymentDate;

  PaymentModel({
    @required this.id,
    @required this.clientWalletId,
    @required this.driverWalletId,
    @required this.amount,
    @required this.paymentDate
  });

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "clientWalletId": this.clientWalletId,
      "driverWalletId": this.driverWalletId,
      "amount": this.amount,
      "paymentDate": this.paymentDate
    };
  }

  static PaymentModel fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      clientWalletId: json['clientWalletId'],
      driverWalletId: json['driverWalletId'],
      amount: json['amount'],
      paymentDate: Utils.timestampToDateTime(json['paymentDate'])
    );
  }

}