import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/ELicencePictureFace.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/shared/LicenceSufixIcons.dart';
import 'package:free_drive/ui/shared/Logo.dart';
import 'package:free_drive/ui/shared/TitleBanner.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

class UploadDriverLicencePage extends StatelessWidget {
  final double _inputSpacingScale = 0.02;
  final double _inputHeightScale = 0.08;
  const UploadDriverLicencePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
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
                SizedBox(height: model.deviceHeight*this._inputSpacingScale),
                SizedBox(height: model.deviceHeight*this._inputSpacingScale),
                TitleBanner(titleText: "Envoyez nous une photo de votre permis de conduire"),
                SizedBox(height: model.deviceHeight*this._inputSpacingScale),
                Form(
                  child: Column(
                    children: [
                      SizedBox(
                        height: model.deviceHeight*_inputHeightScale,
                        child: TextFormField(
                          style: TextStyle(color: Colors.grey),
                          enabled: false,
                          initialValue: "Recto",
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: GestureDetector(
                                onTap: () => model.pickLicencePicture(ELicencePictureFace.verso),
                                child: LicenceSufixIcons()
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 10.0, style: BorderStyle.solid)
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: model.deviceHeight*this._inputSpacingScale),
                      SizedBox(
                        height: model.deviceHeight*_inputHeightScale,
                        child: TextFormField(
                          style: TextStyle(color: Colors.grey),
                          enabled: false,
                          initialValue: "Verso",
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: GestureDetector(
                                onTap: () => model.pickLicencePicture(ELicencePictureFace.verso),
                                child: LicenceSufixIcons()
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 10.0, style: BorderStyle.solid)
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: model.deviceHeight*this._inputSpacingScale),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)
                              )
                          ),
                          onPressed: () => navigatorKey.currentState.pushNamed('/driverDashboard'),
                          child: Text('Valider', style: TextStyle(fontWeight: FontWeight.bold))
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        viewModelBuilder: () => AppViewModel());
  }
}
