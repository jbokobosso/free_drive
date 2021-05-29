import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:stacked/stacked.dart';

class RideDetailsCard extends StatelessWidget {
  final double cardTopSpacingScale = 0.2;
  final double cardWidth = 0.8;
  TextStyle pendingRideStyle = TextStyle(color: Theme.of(navigatorKey.currentContext).primaryColor, fontWeight: FontWeight.bold);
  RideDetailsCard({Key key}) : super(key: key);

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
                Text('\n Type de course: '),
                Text('\n Lieu de départ: '),
                Text("\n Lieu d'arrivée: "),
                Text("\n Date de départ: "),
                Text("\n Date d'arrivée: "),
                Text("\n Durée du voyage: ")
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}
