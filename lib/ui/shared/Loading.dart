import 'package:flutter/material.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:stacked/stacked.dart';

class Loading extends StatelessWidget {
  Loading({Key key}) : super(key: key);
  double cancelRideAlertTopRadius = 20.0;
  int currentNavigationIndex = 1;
  double cardTopSpacingScale = 0.2;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      onModelReady: (model) => model.initEyeAnimation(),
      builder: (context, model, child) => Scaffold(
        body: Container(
          padding: EdgeInsets.only(
              left: model.deviceWidth*0.07,
              right: model.deviceWidth*0.07,
              bottom: model.deviceHeight*0.1
          ),
          width: model.deviceWidth,
          height: model.deviceHeight,
          color: Theme.of(context).accentColor,
          child: Center(child: CircularProgressIndicator())
        ),
      ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}
