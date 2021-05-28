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

customButtonStyle(BuildContext context, {bool isBlack=false, bool isRed=false}) {
  return ElevatedButton.styleFrom(
      primary: isBlack ? Color(0xff333333) : isRed ? Colors.red : Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
      )
  );
}
