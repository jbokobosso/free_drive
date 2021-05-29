import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/shared/AppBanner.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:free_drive/ui/shared/UserDashboardCard.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:stacked/stacked.dart';

class ContactDriverPage extends StatelessWidget {

  final double inputSpacingScale = 0.02;
  final double inputHeightScale = 0.08;
  int currentNavigationIndex = 1;
  ContactDriverPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
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
                      onPressed: () => model.callDriver(),
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
                            height: model.deviceHeight*0.35,
                            child: Form(
                              child: Column(
                                children: [
                                  TextFormField(
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
                                    minLines: 3,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: 'message',
                                      enabledBorder: customInputBorder(context),
                                      border: customInputBorder(context),
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
                                      onPressed: () => model.textDriver(),
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
                        model.contactDriverService.newRide();
                        navigatorKey.currentState.pushNamedAndRemoveUntil("/dashboard", (Route<dynamic> route) => false);
                      },
                      child: Text('Poursuivre')
                  )
                ],
              ),
            ),
            AppBanner(),
            UserDashboardCard(),
          ],
        )
      ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}
