import 'package:flutter/material.dart';
import 'package:free_drive/models/RideModel.dart';
import 'package:free_drive/ui/pages/ask_driver/AskDriverViewModel.dart';
import 'package:free_drive/ui/shared/AppBanner.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:free_drive/ui/shared/Loading.dart';
import 'package:free_drive/ui/shared/UserDashboardCard.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:stacked/stacked.dart';

class ContactDriverPage extends StatelessWidget {

  final double inputSpacingScale = 0.02;
  final double inputHeightScale = 0.08;
  int currentNavigationIndex = 1;
  RideModel ride;
  ContactDriverPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    this.ride = ModalRoute.of(context).settings.arguments;

    return ViewModelBuilder<AskDriverViewModel>.reactive(
      onModelReady: (model) => model.initEyeAnimation(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(title: 'Contact'),
        extendBodyBehindAppBar: true,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: model.deviceHeight*0.1,
                  left: model.deviceWidth*0.07,
                  right: model.deviceWidth*0.07
              ),
              width: model.deviceWidth,
              height: model.deviceHeight,
              color: Theme.of(context).accentColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: model.deviceHeight*0.35),
                  Text('Appelez votre chauffeur', style: Theme.of(context).textTheme.headline1),
                  model.contactedDriver ? Text("") : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10.0)
                      ),
                      onPressed: () => model.callDriver(this.ride.driver.phoneNumber),
                      child: Icon(Icons.phone, size: model.deviceWidth*0.1)
                  ),
                  model.contactedDriver ? Text("") : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff333333),
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(5.0)
                      ),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('SMS'),
                          content: SizedBox(
                            height: model.deviceHeight*0.50,
                            child: Form(
                              key: model.smsFormKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    initialValue: this.ride.driver.phoneNumber,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: 'chauffeur',
                                      enabledBorder: customInputBorder(context),
                                      border: customInputBorder(context),
                                    ),
                                  ),
                                  SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                                  TextFormField(
                                    controller: model.smsMessageCtrl,
                                    minLines: 3,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: 'message',
                                      enabledBorder: customInputBorder(context),
                                      border: customInputBorder(context),
                                    ),
                                    validator: (value) {
                                      if(value.isEmpty)
                                        return "Ecrivez le message";
                                      else return null;
                                    },
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
                                        bool isValid = model.smsFormKey.currentState.validate();
                                        if(!isValid) return;
                                        model.textDriver(this.ride.driver.phoneNumber, model.smsMessageCtrl.text.trim());
                                      },
                                      child: Icon(Icons.send)
                                  ),
                                ],
                              ),
                            ),
                          )
                        )
                      ),
                      child: Icon(Icons.message_rounded, size: model.deviceWidth*0.05)
                  ),
                  ElevatedButton(
                      style: customButtonStyle(context),
                      onPressed: () {
                        model.newRide(ride);
                      },
                      child: Text('Poursuivre')
                  )
                ],
              ),
            ),
            AppBanner(),
            UserDashboardCard(),
            model.isBusy ? Loading() : Container(height: 0, width: 0)
          ],
        )
      ),
      viewModelBuilder: () => AskDriverViewModel(),
    );
  }
}
