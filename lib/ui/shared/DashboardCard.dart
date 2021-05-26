import 'package:flutter/material.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:stacked/stacked.dart';

class DashboardCard extends StatelessWidget {
  double cardTopSpacingScale = 0.2;
  DashboardCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      builder: (context, model, child) => Positioned(
            top: model.deviceHeight*this.cardTopSpacingScale,
            child: Container(
              width: model.deviceWidth*0.7,
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
                        Text('00.000 FCFA', style: Theme.of(context).textTheme.headline6),
                        IconButton(icon: Icon(Icons.add, color: Colors.grey), onPressed: () => null,)
                      ],
                    ),
                    Text('Solde', style: TextStyle(color: Theme.of(context).primaryColor)),
                    Text('\nCourse en attente: 0'),
                    Text('\nCourse en attente: 0'),
                    Text('\nCourse en attente: 0'),
                  ],
                ),
              ),
            ),
          ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}
