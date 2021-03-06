import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_drive/models/RideModel.dart';
import 'package:free_drive/ui/pages/dashboard/DashboardViewModel.dart';
import 'package:free_drive/ui/shared/AppBanner.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:free_drive/ui/shared/DriverDashboardCard.dart';
import 'package:free_drive/ui/shared/Loading.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:free_drive/utils/Utils.dart';
import 'package:stacked/stacked.dart';

class DriverDashboardPage extends StatelessWidget {
  DriverDashboardPage({Key key}) : super(key: key);
  double cancelRideAlertTopRadius = 20.0;
  int currentNavigationIndex = 1;
  double cardTopSpacingScale = 0.2;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
      onModelReady: (model) => model.initDriverViewPage(),
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
                  model.activeRide != null && model.activeRide.rideState != ERideState.done
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Départ - '+ Utils.formatDateToHuman(model.activeRide.departureDate)),
                            Text('Retour - '+ Utils.formatDateToHuman(model.activeRide.departureDate)),
                            Text('Lieu de départ - '+ model.activeRide.departureLocation.toString()),
                            Text('Destination - '+ model.activeRide.destinationLocation.name),
                            Text('Client - ' + model.activeRide.client.displayName),
                            model.activeRide.rideState == ERideState.pending
                                ? ElevatedButton(
                                    style: customButtonStyle(context),
                                    onPressed: () => model.acceptRide(),
                                    child: Text('Accepter La course', style: TextStyle(fontWeight: FontWeight.bold))
                                  ) : Container(),
                            model.activeRide.rideState == ERideState.accepted
                                ? ElevatedButton(
                                    style: customButtonStyle(context, isAction: true),
                                    onPressed: () => model.startRide(),
                                    child: Text('Démarrer la course', style: TextStyle(fontWeight: FontWeight.bold))
                                  ): Container()
                          ],
                        ) : Container(),
                  model.driverProfileIsActive == false ? Center(child: Text("Votre inscription a été bien efffectuée et est en attente de validation.", style: Theme.of(context).textTheme.headline1)) : Container(),
                  model.driverProfileIsActive == false ? SizedBox(height: model.deviceHeight*0.05) : Container(),
                  model.driverProfileIsActive == false ? Text("Vous serez invité à passer un test.", style: TextStyle(color: Theme.of(context).primaryColor)) : Container()
                ],
              ),
            ),
            AppBanner(),
            model.activeRide != null ? DriverDashboardCard(ride: model.activeRide) : DriverDashboardCard(),
            model.isBusy ? Loading() : Container(height: 0, width: 0)
          ],
        ),
      ),
      viewModelBuilder: () => DashboardViewModel(),
    );
  }
}
