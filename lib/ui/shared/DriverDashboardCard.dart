import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:stacked/stacked.dart';

class DriverDashboardCard extends StatelessWidget {
  final double cardTopSpacingScale = 0.2;
  final double cardWidth = 0.8;
  TextStyle hightlightStyle = TextStyle(color: Theme.of(navigatorKey.currentContext).primaryColor, fontWeight: FontWeight.bold);
  DriverDashboardCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      builder: (context, model, child) => Positioned(
        top: model.deviceHeight*this.cardTopSpacingScale,
        child: Container(
          width: model.deviceWidth*this.cardWidth,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${model.coreService.driverDashboardState.balance ?? 00.0} FCFA", style: Theme.of(context).textTheme.headline6),
                    IconButton(icon: Icon(Icons.add, color: Colors.grey), onPressed: () => null,)
                  ],
                ),
                Text('Gain', style: TextStyle(color: Theme.of(context).primaryColor)),
                GestureDetector(
                  onTap: () => navigatorKey.currentState.pushNamed("/rideDetails"),
                  child: Text(
                    '\nCourse en attente: ${model.coreService.driverDashboardState.pendingRideExists ? 1 : 0}',
                    style: model.coreService.driverDashboardState.pendingRideExists ? this.hightlightStyle : TextStyle(),
                  ),
                ),
                GestureDetector(
                  onTap: () => navigatorKey.currentState.pushNamed("/rideDetails"),
                  child: Text(
                    '\nCourse en cours: ${model.coreService.driverDashboardState.activeRideExists ? 1 : 0}',
                    style: model.coreService.driverDashboardState.activeRideExists ? this.hightlightStyle : TextStyle(),
                  ),
                ),
                Text('\nCourses terminée: ${model.coreService.driverDashboardState.completedRidesCount}'),
                Text('\nStatut: : ${model.coreService.driverDashboardState.isActiveAccount ? "Activé" : "Non actif"}'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("\nAvis: "),
                    Icon(Icons.star, color: Colors.grey),
                    Icon(Icons.star, color: Colors.grey),
                    Icon(Icons.star, color: Colors.grey),
                    Icon(Icons.star, color: Colors.grey),
                    Icon(Icons.star, color: Colors.grey),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}
