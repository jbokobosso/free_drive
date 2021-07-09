import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/shared/Loading.dart';
import 'package:stacked/stacked.dart';

class ProfileCard extends StatelessWidget {
  final double cardTopSpacingScale = 0.2;
  final double cardWidth = 0.8;
  TextStyle hightlightStyle = TextStyle(color: Theme.of(navigatorKey.currentContext).primaryColor, fontWeight: FontWeight.bold);
  ProfileCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      onModelReady: (model) => model.loadLocallyLoggedUser(),
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
            child: model.loggedUser != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Icon(Icons.person, size: model.deviceWidth*0.5)),
                Text('\n ${model.loggedUser.displayName}'),
                Text('\n ${model.loggedUser.phoneNumber}'),
                Text('\n ${model.loggedUser.email}'),
                model.coreService.loggedUser.userType == EUserType.driver // if user is driver, show account status. If not, show nothing (because client users are active by default)
                    ? Text('\nStatut: ${model.coreService.driverDashboardState.isActiveAccount ? "Activé" : "Non actif"}')
                    : Text(""),
                model.isBusy ? Center(child: Loading()) : SizedBox(height: 0, width: 0)
              ],
            )
                : Center(child: CircularProgressIndicator())
          ),
        ),
      ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}
