import 'package:flutter/foundation.dart';

class Wallet {
  String id;
  double balance;

  Wallet({@required this.id, @required this.balance});

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "balance": this.balance
    };
  }

  static Wallet fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      balance: json['balance']
    );
  }


}