import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/ui/pages/auth/AuthViewModel.dart';
import 'package:free_drive/ui/shared/Loading.dart';
import 'package:free_drive/ui/shared/Logo.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:stacked/stacked.dart';

class RecoverPasswordPage extends StatelessWidget {

  final double inputSpacingScale = 0.02;
  final double inputHeightScale = 0.09;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Container(
          padding: EdgeInsets.only(
              left: model.deviceWidth*0.1,
              right: model.deviceWidth*0.1
          ),
          width: model.deviceWidth,
          color: Theme.of(context).accentColor,
          child: model.isBusy ? Center(child: Loading()) : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Logo(sizeScale: 0.2),
              SizedBox(height: model.deviceHeight*this.inputSpacingScale),
              Align(
                alignment: Alignment.center,
                child: Text(
                    'Recupérer votre mot de passe',
                    style: Theme.of(context).textTheme.headline1
                ),
              ),
              SizedBox(height: model.deviceHeight*this.inputSpacingScale),
              Form(
                key: model.recoveryFormKey,
                child: Column(
                  children: [
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)
                          )
                      ),
                      child: Text('Procéder'),
                      onPressed: () => model.recoverPassword(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => AuthViewModel(),
    );
  }
}