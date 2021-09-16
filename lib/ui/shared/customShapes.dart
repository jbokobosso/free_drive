import 'package:flutter/material.dart';

customInputBorder(BuildContext context) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          style: BorderStyle.solid,
          width: 1.0
      )
  );
}

customButtonStyle(BuildContext context, {bool isAction=false, bool isDanger=false, bool isSuccess=false}) {
  return ElevatedButton.styleFrom(
      primary: isAction ? Color(0xff333333) : isDanger ? Colors.red : isSuccess ? Colors.green : Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
      )
  );
}
