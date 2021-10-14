import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:free_drive/utils/Utils.dart';

enum EWalletLoadStatus {
  pending,
  done
}

class Load {
  String id;
  String clientWalletId;
  double amount;
  EWalletLoadStatus loadStatus;
  DateTime loadDatetime;
  DateTime completedAt;

  Load(
      {
        @required this.id,
        @required this.clientWalletId,
        @required this.amount,
        @required this.loadStatus,
        @required this.loadDatetime,
        @required this.completedAt
      });

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "clientWalletId": this.clientWalletId,
      "amount": this.amount,
      "loadStatus": EnumToString.convertToString(this.loadStatus),
      "loadDatetime": this.loadDatetime,
      "completedAt": this.completedAt
    };
  }

  Load fromJson(Map<String, dynamic> json) {
    return Load(
      id: json['id'],
      clientWalletId: json['clientWalletId'],
      amount: json['amount'],
      loadStatus: EnumToString.fromString([EWalletLoadStatus.done, EWalletLoadStatus.pending], json['loadStatus']),
      loadDatetime: Utils.timestampToDateTime(json['loadDatetime']),
      completedAt: json['completedAt']
    );
  }
}