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

customButtonStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
      primary: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
      )
  );
}
