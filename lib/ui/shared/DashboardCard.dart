import 'package:flutter/material.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:stacked/stacked.dart';

class DashboardCard extends StatelessWidget {
  final double cardTopSpacingScale = 0.2;
  final double pageWidth = 0.8;
  DashboardCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      builder: (context, model, child) => Positioned(
            top: model.deviceHeight*this.cardTopSpacingScale,
            child: Container(
              width: model.deviceWidth*this.pageWidth,
              height: model.deviceHeight*0.3,
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
                        Text("${model.coreService.dashboardState.balance ?? 00.0} FCFA", style: Theme.of(context).textTheme.headline6),
                        IconButton(icon: Icon(Icons.add, color: Colors.grey), onPressed: () => null,)
                      ],
                    ),
                    Text('Solde', style: TextStyle(color: Theme.of(context).primaryColor)),
                    Text('\nCourse en attente: ${model.coreService.dashboardState.pendingRideExists ? 1 : 0}'),
                    Text('\nCourse en cours: ${model.coreService.dashboardState.activeRideExists ? 1 : 0}'),
                    Text('\nCourse en terminée: ${model.coreService.dashboardState.completedRidesCount}'),
                  ],
                ),
              ),
            ),
          ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}
