import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/ui/shared/customShapes.dart';

class Button extends StatelessWidget {
  Function callback;
  bool isAction;
  bool isDanger;
  bool isSuccess;
  String text;
  Button(this.callback, this.text, {bool isAction=false, bool isDanger=false, bool isSuccess=false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      child: Text(this.text),
      style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)
          )
      )
    );
  }
}
