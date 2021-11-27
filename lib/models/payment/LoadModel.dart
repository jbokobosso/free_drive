import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:free_drive/models/EPaymentMethod.dart';
import 'package:free_drive/utils/Utils.dart';

enum EWalletLoadStatus {
  pending,
  done
}

class LoadModel {
  String id;
  String clientId;
  double amount;
  EWalletLoadStatus loadStatus;
  DateTime loadDatetime;
  DateTime completedAt;
  String txRef;
  EPaymentMethod paymentMethod;
  String phoneNumber;

  LoadModel(
      {
        @required this.id,
        @required this.clientId,
        @required this.amount,
        @required this.loadStatus,
        @required this.loadDatetime,
        @required this.completedAt,
        @required this.txRef,
        @required this.paymentMethod,
        @required this.phoneNumber,
      });

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "clientWalletId": this.clientId,
      "amount": this.amount,
      "loadStatus": EnumToString.convertToString(this.loadStatus),
      "loadDatetime": this.loadDatetime,
      "completedAt": this.completedAt,
      "tx_ref": this.txRef,
      "paymentMethod": EnumToString.convertToString(this.paymentMethod),
      "phoneNumber": this.phoneNumber,
    };
  }

  static LoadModel fromJson(Map<String, dynamic> json) {
    return LoadModel(
      id: json['id'],
      clientId: json['clientWalletId'],
      amount: json['amount'],
      loadStatus: EnumToString.fromString([EWalletLoadStatus.done, EWalletLoadStatus.pending], json['loadStatus']),
      loadDatetime: Utils.timestampToDateTime(json['loadDatetime']),
      completedAt: Utils.timestampToDateTime(json['completedAt']),
      txRef: json['tx_ref'],
      paymentMethod: EnumToString.fromString([EPaymentMethod.FLOOZ, EPaymentMethod.TMONEY], json['paymentMethod']),
      phoneNumber: json['phoneNumber'],
    );
  }
}