import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/shared/Logo.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

class LoginPage extends StatelessWidget {
  bool isObscure = true;
  double inputSpacingScale = 0.02;
  double inputHeightScale = 0.06;
  double radioFontSize = 10.0;
  EUserType _userType;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      onModelReady: (model) => model.initRiveAnimation(),
      builder: (context, model, child) => Scaffold(
        body: Container(
          padding: EdgeInsets.only(
              top: model.deviceHeight*0.1,
              left: model.deviceWidth*0.07,
              right: model.deviceWidth*0.07
          ),
          width: model.deviceWidth,
          color: Theme.of(context).accentColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Logo(sizeScale: 0.35),
              SizedBox(height: model.deviceHeight*this.inputSpacingScale),
              SizedBox(height: model.deviceHeight*this.inputSpacingScale),
              Form(
                child: Column(
                  children: [
                    SizedBox(
                      height: model.deviceHeight*inputHeightScale,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 10.0, style: BorderStyle.solid)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                    SizedBox(
                      height: model.deviceHeight*inputHeightScale,
                      child: TextFormField(
                        obscureText: this.isObscure,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Mot de passe',
                          suffixIcon: IconButton(
                            icon: model.riveArtboard == null
                                ? Icon(Icons.remove_red_eye)
                                : Container(
                                    child: Rive(artboard: model.riveArtboard, fit: BoxFit.contain)
                                  ),
                            onPressed: () {
                              this.isObscure = !this.isObscure;
                              this.isObscure
                                  ? model.riveArtboard.addController(model.riveAnimationController = SimpleAnimation("close"))
                                  : model.riveArtboard.addController(model.riveAnimationController = SimpleAnimation("open"));
                              model.notifyListeners();
                            },
                          ),
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
                        onPressed: () => navigatorKey.currentState.pushNamed('/dashboard'),
                        child: Text('Connexion', style: TextStyle(fontWeight: FontWeight.bold))
                    ),
                    SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                    Text('ou'),
                    SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                    TextButton(
                      child: Text('Créer un compte'),
                      onPressed: () => navigatorKey.currentState.pushNamed("/signup"),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}
