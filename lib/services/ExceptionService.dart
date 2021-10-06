import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/ServiceLocator.dart';

class ExceptionService {

  CoreService _coreService = getIt.get<CoreService>();

  manageExCeption(dynamic exception) {
    switch(exception.runtimeType) {
      case Exception:
        this._coreService.showErrorDialog("Erreur", exception.toString());
        break;
      case ArgumentError:
        manageArgumentError(exception);
        break;
      default:
        throw exception;
        break;
    }
  }

  manageArgumentError(ArgumentError exception) {
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
  }

}