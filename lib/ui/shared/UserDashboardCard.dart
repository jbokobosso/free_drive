import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/RideModel.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/pages/dashboard/DashboardViewModel.dart';
import 'package:stacked/stacked.dart';

class UserDashboardCard extends StatelessWidget {
  final double cardTopSpacingScale = 0.2;
  final double cardWidth = 0.8;
  final double cardHeight = 0.35;
  RideModel ride;
  UserDashboardCard({this.ride, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
      builder: (context, model, child) => Positioned(
            top: model.deviceHeight*this.cardTopSpacingScale,
            child: Container(
              width: model.deviceWidth*this.cardWidth,
              height: model.deviceHeight*cardHeight,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Theme.of(context).primaryColor,
                        spreadRadius: 0.1,
                        blurRadius: 0.5
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Solde', style: TextStyle(color: Theme.of(context).primaryColor)),
                    GestureDetector(
                      onTap: () => navigatorKey.currentState.pushNamed("/pendingPayments"),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${model.coreService.userDashboardState.balance ?? 00.0} FCFA", style: Theme.of(context).textTheme.headline6),
                          IconButton(icon: Icon(Icons.add, color: Colors.grey), onPressed: () => model.buildShowDialog(context),)
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.history),
                        Text('${model.coreService.userDashboardState.completedRidesCount} courses total')
                      ],
                    ),
                    this.ride != null && this.ride.rideState == ERideState.pending ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.motorcycle, color: Colors.yellow,),
                        Text('Vous avez une course en attente...', style: TextStyle(color: Colors.yellow))
                      ],
                    ) : Container(),
                    this.ride != null && this.ride.rideState == ERideState.running ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.motorcycle, color: Colors.blue,),
                        Text('Course en cours...', style: TextStyle(color: Colors.blue))
                      ],
                    ) : Container(),
                    this.ride != null && this.ride.rideState == ERideState.accepted ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.motorcycle, color: Colors.blue,),
                        Text('Votre course a ??t?? accept??', style: TextStyle(color: Colors.blue))
                      ],
                    ) : Container(),
                  ],
                ),
              ),
            ),
          ),
      viewModelBuilder: () => DashboardViewModel(),
    );
  }
}
