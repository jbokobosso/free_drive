import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/shared/Logo.dart';
import 'package:free_drive/ui/shared/TitleBanner.dart';
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
                    TitleBanner(titleText: "Entrez votre code de confirmation"),
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
                          'Bravo ! votre compte a ??t?? cr??e avec succ??s',
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
                        onPressed: () {
                          if(model.userType == EUserType.client)
                            navigatorKey.currentState.pushNamed('/dashboard');
                          else if(model.userType == EUserType.driver)
                            navigatorKey.currentState.pushNamed('/uploadDriverLicence');
                          else
                            print("Nothing to do");
                        },
                        child: Text('Allez ?? votre tableau de bord', style: TextStyle(fontWeight: FontWeight.bold))
                    )
                  ],
                )
        ),
      ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}
