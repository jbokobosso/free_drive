import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:stacked/stacked.dart';

class AppBanner extends StatelessWidget {
  bool showNotifIcon;
  bool showProfileIcon;
  AppBanner({
    Key key,
    this.showProfileIcon = true,
    this.showNotifIcon = true
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
            this.showProfileIcon ? IconButton(icon: Icon(Icons.person, color: Colors.white), onPressed: () => navigatorKey.currentState.pushNamed("/profile")) : Text(""),
            this.showNotifIcon ? Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Badge(
                badgeContent: Text("10", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                badgeColor: Colors.black,
                child: IconButton(
                  icon: Icon(Icons.notifications, color: Colors.white),
                  onPressed: () => navigatorKey.currentState.pushNamed("/notifs")
                )
              ),
            ) : Text(""),
          ],
        ),
      ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}