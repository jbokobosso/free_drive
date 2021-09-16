import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/ServiceLocator.dart';

class ExceptionService {

  CoreService _coreService = getIt.get<CoreService>();

  manageExCeption(dynamic exception) {
    if(exception.runtimeType == Exception) {
      this._coreService.showErrorDialog("Erreur", exception.toString());
    } else if(exception.runtimeType == ArgumentError) {
      ArgumentError error = exception;
      this._coreService.showRichTextDialog("Argument Firebase Invalide", RichText(
        text: TextSpan(
          text: "L'argument firebase ",
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(text: "${error.invalidValue}", style: TextStyle(color: Colors.blue)),
            TextSpan(text: " n'est pas valide", style: TextStyle(color: Colors.black))
          ]
        ),
      ));
    } else {
      throw exception;
    }
  }

}