import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:free_drive/ui/shared/Logo.dart';
import 'package:stacked/stacked.dart';

class AuthPage extends StatelessWidget {
  bool isObscure = true;
  double inputSpacingScale = 0.02;
  double inputHeightScale = 0.05;
  double radioFontSize = 10.0;
  EUserType _userType;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: model.deviceWidth*0.1),
          width: model.deviceWidth,
          color: Theme.of(context).accentColor,
          child: ListView(
            padding: EdgeInsets.all(0.0),
            children: [
              Logo(sizeScale: 0.35),
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
                child: Column(
                  children: [
                    SizedBox(
                      height: model.deviceHeight*inputHeightScale,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Nom et prénoms',
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
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'N° de Téléphone',
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
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Adresse',
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
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              this.isObscure = !this.isObscure;
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
                    SizedBox(
                      height: model.deviceHeight*inputHeightScale,
                      child: TextFormField(
                        obscureText: this.isObscure,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Confirmer mot de passe',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              this.isObscure = !this.isObscure;
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
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: const Text('Client', style: TextStyle(fontSize: 12.0)),
                            leading: Radio<EUserType>(
                              activeColor: Theme.of(context).primaryColor,
                              value: EUserType.client,
                              groupValue: _userType,
                              onChanged: (EUserType value) {
                                _userType = value;
                                model.notifyListeners();
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('Chauffeur', style: TextStyle(fontSize: 12.0)),
                            leading: Radio<EUserType>(
                              activeColor: Theme.of(context).primaryColor,
                              value: EUserType.chauffeur,
                              groupValue: _userType,
                              onChanged: (EUserType value) {
                                _userType = value;
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
                      onPressed: () => print('Next !!!'),
                      child: Text('Suivant')
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