import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/pages/dashboard/extend_ride_dialog.dart';
import 'package:free_drive/ui/shared/AppBanner.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:free_drive/ui/shared/RideDetailsCard.dart';
import 'package:free_drive/ui/shared/UserDashboardCard.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:stacked/stacked.dart';

class RideDetailsPage extends StatelessWidget {
  RideDetailsPage({Key key}) : super(key: key);
  double cancelRideAlertTopRadius = 20.0;
  int currentNavigationIndex = 1;
  double cardTopSpacingScale = 0.2;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      onModelReady: (model) => model.initEyeAnimation(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(title: 'Détails de la course'),
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
                  model.coreService.driverDashboardState.pendingRideExists
                      ? ElevatedButton(
                          style: customButtonStyle(context),
                          onPressed: () => showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(this.cancelRideAlertTopRadius))
                              ),
                              titlePadding: EdgeInsets.all(0.0),
                              title: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(this.cancelRideAlertTopRadius))
                                ),
                                width: double.infinity,
                                height: 30.0,
                                child: Align(child: Text("Attention", style: TextStyle(color: Colors.white)), alignment: Alignment.center),
                              ),
                              content: Text('Confirmez que vous démarrez la course'),
                              actions: [
                                TextButton(child: Text('Oui'), onPressed: () => model.startRide()),
                                TextButton(child: Text('Non'), onPressed: () => navigatorKey.currentState.pop()),
                              ],
                            )
                          ),
                          child: Text('Démarrer la course', style: TextStyle(fontWeight: FontWeight.bold))
                        )
                      : model.coreService.driverDashboardState.activeRideExists
                      ? ElevatedButton(
                          style: customButtonStyle(context),
                          onPressed: () => showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(this.cancelRideAlertTopRadius))
                              ),
                              titlePadding: EdgeInsets.all(0.0),
                              title: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(this.cancelRideAlertTopRadius))
                                ),
                                width: double.infinity,
                                height: 30.0,
                                child: Align(child: Text("Attention", style: TextStyle(color: Colors.white)), alignment: Alignment.center),
                              ),
                              content: Text('Voulez-vous terminer la course ?'),
                              actions: [
                                TextButton(child: Text('Oui'), onPressed: () => model.completeRide()),
                                TextButton(child: Text('Non'), onPressed: () => navigatorKey.currentState.pop()),
                              ],
                            )
                          ),
                          child: Text('Terminer la course', style: TextStyle(fontWeight: FontWeight.bold))
                        ) : Text(""),
                ],
              ),
            ),
            AppBanner(),
            RideDetailsCard(),
          ],
        ),
      ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}
