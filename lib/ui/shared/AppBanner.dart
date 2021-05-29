import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:stacked/stacked.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      onModelReady: (model) => model.initEyeAnimation(),
      builder: (context, model, child) => Container(
        padding: EdgeInsets.only(top: 55),
        height: model.deviceHeight*0.25,
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(icon: Icon(Icons.person, color: Colors.white), onPressed: () => null),
            IconButton(icon: Icon(Icons.notifications, color: Colors.white), onPressed: () => navigatorKey.currentState.pushNamed("/notifs")),
          ],
        ),
      ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}