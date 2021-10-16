import 'package:flutter/material.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/utils/Utils.dart';
import 'package:lottie/lottie.dart';
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
          width: model.deviceWidth,
          height: model.deviceHeight,
          color: Theme.of(context).accentColor,
          child: Center(child: Lottie.asset("assets/lottie/loading-tire.json", width: 150))
        ),
      ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}

class LoadingMini extends StatelessWidget {
  const LoadingMini({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset("assets/lottie/loading-tire.json", width: 150));
  }
}

