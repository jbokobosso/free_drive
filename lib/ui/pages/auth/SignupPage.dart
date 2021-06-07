import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/shared/Loading.dart';
import 'package:free_drive/ui/shared/Logo.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

class SignupPage extends StatelessWidget {
  bool isObscure = true;
  double inputSpacingScale = 0.02;
  double inputHeightScale = 0.09;
  double radioFontSize = 10.0;
  EUserType _userTypeChosen=EUserType.client;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      onModelReady: (model) => model.initEyeAnimation(),
      builder: (context, model, child) => Scaffold(
        body: Container(
          padding: EdgeInsets.only(
            left: model.deviceWidth*0.1,
            right: model.deviceWidth*0.1
          ),
          width: model.deviceWidth,
          color: Theme.of(context).accentColor,
          child: model.isBusy ? Center(child: Loading()) : ListView(
            padding: EdgeInsets.all(0.0),
            children: [
              SizedBox(height: model.deviceHeight*0.1),
              Logo(sizeScale: 0.2),
              SizedBox(height: model.deviceHeight*this.inputSpacingScale),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Entrez vos informations pour créer votre compte',
                  style: Theme.of(context).textTheme.headline1
                ),
              ),
              SizedBox(height: model.deviceHeight*this.inputSpacingScale),
              Form(
                key: model.signupFormKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: model.deviceHeight*inputHeightScale,
                      child: TextFormField(
                        controller: model.displayNameCtrl,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Saisir nom complet';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Prénom suivi du nom',
                          enabledBorder: customInputBorder(context),
                          border: customInputBorder(context),
                        ),
                      ),
                    ),
                    SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                    SizedBox(
                      height: model.deviceHeight*inputHeightScale,
                      child: TextFormField(
                        controller: model.emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Champ requis';
                          }
                          if(!model.coreService.validateEmail(value)) {
                            return "Ceci n'est pas une adresse mail";
                          }
                          return null;
                        },
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
                        controller: model.phoneNumberCtrl,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Téléphone requis';
                          }
                          if(!model.coreService.validatePhoneNumber(value)) {
                            return "Numéro invalide. Ex: +228xxxxxxxx";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'N° de Téléphone',
                          enabledBorder: customInputBorder(context),
                          border: customInputBorder(context),
                        ),
                      ),
                    ),
                    SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                    SizedBox(
                      child: TextFormField(
                        minLines: 3,
                        maxLines: 4,
                        controller: model.addressCtrl,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Adresse requise';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Adresse',
                          enabledBorder: customInputBorder(context),
                          border: customInputBorder(context),
                        ),
                      ),
                    ),
                    SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                    SizedBox(
                      height: model.deviceHeight*inputHeightScale,
                      child: TextFormField(
                        controller: model.passCtrl,
                        obscureText: this.isObscure,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Choisissez un mot de passe';
                          }
                          return null;
                        },
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
                    SizedBox(
                      height: model.deviceHeight*inputHeightScale,
                      child: TextFormField(
                        controller: model.confirmPassCtrl,
                        obscureText: this.isObscure,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vous devez confirmer le mot de passe';
                          }
                          if (value != model.passCtrl.text) {
                            return 'Les deux mots de passe ne concordent pas';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Confirmer mot de passe',
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
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            horizontalTitleGap: 0,
                            title: const Text('Client', style: TextStyle(fontSize: 12.0)),
                            leading: Radio<EUserType>(
                              activeColor: Theme.of(context).primaryColor,
                              value: EUserType.client,
                              groupValue: _userTypeChosen,
                              onChanged: (EUserType value) {
                                _userTypeChosen = value;
                                model.notifyListeners();
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            horizontalTitleGap: 0,
                            title: const Text('Chauffeur', style: TextStyle(fontSize: 12.0)),
                            leading: Radio<EUserType>(
                              activeColor: Theme.of(context).primaryColor,
                              value: EUserType.driver,
                              groupValue: _userTypeChosen,
                              onChanged: (EUserType value) {
                                _userTypeChosen = value;
                                model.notifyListeners();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                        )
                      ),
                      onPressed: () => model.registerUser(this._userTypeChosen),
                      child: Text('Suivant')
                    ),
                    SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                    Text('ou'),
                    SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                    TextButton(
                      child: Text('Se connecter'),
                      onPressed: () => navigatorKey.currentState.pushNamedAndRemoveUntil("/login", (route) => false),
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