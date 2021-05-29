import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/ELicencePictureFace.dart';
import 'package:free_drive/models/ERideType.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/shared/LicenceSufixIcons.dart';
import 'package:free_drive/ui/shared/Logo.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

class LoginPage extends StatelessWidget {
  bool isObscure = true;
  final double inputSpacingScale = 0.02;
  final double inputHeightScale = 0.08;
  final double radioFontSize = 10.0;
  ERideType chosenRide = ERideType.hint;

  heightSpacing() {
    return SizedBox(height: 10.0);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      onModelReady: (model) {
        model.initEyeAnimation();
        model.initTurnLogoAnimation();
      },
      builder: (context, model, child) => Scaffold(
        body: Container(
          padding: EdgeInsets.only(
              top: model.deviceHeight*0.1,
              left: model.deviceWidth*0.07,
              right: model.deviceWidth*0.07
          ),
          width: model.deviceWidth,
          color: Theme.of(context).accentColor,
          child: ListView(
            children: [
              model.logoArtboard == null
                  ? Logo(sizeScale: 0.35)
                  : Container(
                      height: model.deviceHeight*0.20,
                      child: Rive(artboard: model.logoArtboard, fit: BoxFit.contain)
                    ),
              SizedBox(height: model.deviceHeight*this.inputSpacingScale),
              SizedBox(height: model.deviceHeight*this.inputSpacingScale),
              Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Qui êtes vous ?"),
                    DropdownButtonFormField<EUserType>(
                      onChanged: (newValue) => model.chooseUserType(newValue),
                      value: model.userType,
                      decoration: InputDecoration(
                        enabledBorder: customInputBorder(context),
                        border: customInputBorder(context),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                      ),
                      items: [
                        DropdownMenuItem(child: Text("Choisissez s'il vous plait", style: TextStyle(color: Colors.grey),), value: EUserType.hint),
                        DropdownMenuItem(child: Text('JE SUIS CLIENT'), value: EUserType.client),
                        DropdownMenuItem(child: Text('JE SUIS CHAUFFEUR'), value: EUserType.driver),
                      ],
                    ),
                  ],
                ),
              ),
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
                                enabledBorder: customInputBorder(context),
                                border: customInputBorder(context),
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
                                  icon: model.eyeArtboard == null
                                      ? Icon(Icons.remove_red_eye)
                                      : Container(
                                          child: Rive(artboard: model.eyeArtboard, fit: BoxFit.contain)
                                        ),
                                  onPressed: () {
                                    this.isObscure = !this.isObscure;
                                    this.isObscure
                                        ? model.eyeArtboard.addController(model.eyeAnimationController = SimpleAnimation("close"))
                                        : model.eyeArtboard.addController(model.eyeAnimationController = SimpleAnimation("open"));
                                    model.notifyListeners();
                                  },
                                ),
                                enabledBorder: customInputBorder(context),
                                border: customInputBorder(context),
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
                            child: Text('Connexion', style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: () {
                              if(model.userType == EUserType.client)
                                navigatorKey.currentState.pushNamed('/dashboard');
                              else if(model.userType == EUserType.driver)
                                navigatorKey.currentState.pushNamed('/driverDashboard');
                              else
                                print("Nothing to do");
                            },
                          ),
                          SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                          Text('ou'),
                          SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                          TextButton(
                            child: Text('Créer un compte'),
                            onPressed: () => navigatorKey.currentState.pushNamedAndRemoveUntil("/signup", (route) => false),
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
