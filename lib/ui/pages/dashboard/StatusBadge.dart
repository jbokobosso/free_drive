import 'package:flutter/material.dart';
import 'package:free_drive/models/payment/PendingPayment.dart';
import 'package:free_drive/utils/Utils.dart';

class StatusBadge extends StatelessWidget {
  final PendingPaymentModel _pendingPayment;
  StatusBadge(this._pendingPayment, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Utils.getPendingPaymentBadgeColor(_pendingPayment),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          Utils.convertPaymentStatusToHumanReadableFormat(_pendingPayment.status),
          style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold, color: Colors.white),
        )
    );
  }
}
