import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/ui/pages/dashboard/DashboardViewModel.dart';
import 'package:free_drive/ui/pages/dashboard/extend_ride_dialog.dart';
import 'package:free_drive/ui/shared/AppBanner.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:free_drive/ui/shared/Loading.dart';
import 'package:free_drive/ui/shared/UserDashboardCard.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:stacked/stacked.dart';

class UserDashboardPage extends StatelessWidget {
  UserDashboardPage({Key key}) : super(key: key);
  double cancelRideAlertTopRadius = 20.0;
  int currentNavigationIndex = 1;
  double cardTopSpacingScale = 0.2;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
      onModelReady: (model) => model.initUserViewPage(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(title: 'Tableau de bord'),
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
                  model.activeRide != null
                      ? ElevatedButton(
                          style: customButtonStyle(context, isBlack: true),
                          onPressed: () => showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) => ExtendRideDialog(cancelRideAlertTopRadius: cancelRideAlertTopRadius)
                          ),
                          child: Text('Prolonger la course', style: TextStyle(fontWeight: FontWeight.bold))
                        )
                      : Text(''),
                  model.activeRide != null
                      ? ElevatedButton(
                          style: customButtonStyle(context, isRed: true),
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
                                child: Align(child: Text("Confirmez", style: TextStyle(color: Colors.white)), alignment: Alignment.center),
                              ),
                              content: Text('Etes vous sûr de vouloir annuler la course en cours ?'),
                              actions: [
                                TextButton(child: Text('Oui'), onPressed: () => model.cancelActiveRide()),
                                TextButton(child: Text('Non'), onPressed: () => navigatorKey.currentState.pop()),
                              ],
                            )
                          ),
                          child: Text('Annuler la course', style: TextStyle(fontWeight: FontWeight.bold))
                        )
                      : ElevatedButton(
                      style: customButtonStyle(context),
                      onPressed: () => navigatorKey.currentState.pushNamed('/askDriver'),
                      child: Text('Demander un chauffeur', style: TextStyle(fontWeight: FontWeight.bold))
                  )
                ],
              ),
            ),
            AppBanner(),
            model.activeRide != null ? UserDashboardCard(ride: model.activeRide) : UserDashboardCard(),
            model.isBusy ? Loading() : Container(height: 0, width: 0),
          ],
        ),
      ),
      viewModelBuilder: () => DashboardViewModel(),
    );
  }
}
