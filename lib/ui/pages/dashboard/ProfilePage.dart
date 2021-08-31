import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/shared/AppBanner.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:free_drive/ui/shared/profileCard/ProfileCard.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:stacked/stacked.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key key}) : super(key: key);
  double cancelRideAlertTopRadius = 20.0;
  int currentNavigationIndex = 1;
  double cardTopSpacingScale = 0.2;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      onModelReady: (model) => model.initEyeAnimation(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(title: 'Mon Profil'),
        extendBodyBehindAppBar: true,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: model.deviceWidth*0.07,
                  right: model.deviceWidth*0.07,
                  bottom: model.deviceHeight*0.1
              ),
              width: model.deviceWidth,
              height: model.deviceHeight,
              color: Theme.of(context).accentColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 0, width: 0),
                  Center(
                    child: ElevatedButton(
                      style: customButtonStyle(context),
                      child: Text("Déconnexion"),
                      onPressed: () => model.logout(),
                    ),
                  )
                ],
              ),
            ),
            AppBanner(showProfileIcon: false, showNotifIcon: false),
            ProfileCard()
          ],
        ),
      ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}
