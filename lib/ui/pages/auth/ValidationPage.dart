import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/shared/Logo.dart';
import 'package:stacked/stacked.dart';

class ValidationPage extends StatelessWidget {
  bool isValidated = false;
  double inputSpacingScale = 0.02;
  double inputHeightScale = 0.08;
  ValidationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: model.deviceWidth*0.1),
          width: model.deviceWidth,
          color: Theme.of(context).accentColor,
          child: !this.isValidated
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Logo(sizeScale: 0.35),
                    SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                          'Entrez votre code de confirmation',
                          style: Theme.of(context).textTheme.headline1
                      ),
                    ),
                    SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                    Form(
                      child: Column(
                        children: [
                          SizedBox(
                            height: model.deviceHeight*inputHeightScale,
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Code de confirmation',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 10.0, style: BorderStyle.solid)
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0)
                                  )
                              ),
                              onPressed: () {this.isValidated = true; model.notifyListeners();},
                              child: Text('Valider', style: TextStyle(fontWeight: FontWeight.bold))
                          )
                        ],
                      ),
                    )
                  ],
                )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Logo(sizeScale: 0.35),
                    SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                          'Bravo ! votre compte a été crée avec succès',
                          style: Theme.of(context).textTheme.headline1
                      ),
                    ),
                    SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)
                            )
                        ),
                        onPressed: () => navigatorKey.currentState.pushNamed('/dashboard'),
                        child: Text('Allez à votre tableau de bord', style: TextStyle(fontWeight: FontWeight.bold))
                    )
                  ],
                )
        ),
      ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}
