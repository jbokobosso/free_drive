import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/pages/dashboard/extend_ride_dialog.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:free_drive/ui/shared/DashboardCard.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:stacked/stacked.dart';

class NavigationStarter extends StatelessWidget {
  NavigationStarter({Key key}) : super(key: key);
  double cancelRideAlertTopRadius = 20.0;
  int currentNavigationIndex = 1;
  double cardTopSpacingScale = 0.2;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      onModelReady: (model) => model.initEyeAnimation(),
      builder: (context, model, child) => Scaffold(
        extendBodyBehindAppBar: true,
        body: model.coreService.navigationPages[this.currentNavigationIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: this.currentNavigationIndex,
          onTap: (newIndex) {
            this.currentNavigationIndex = newIndex;
            model.notifyListeners();
          },
          elevation: 0.0,
          backgroundColor: Theme.of(context).accentColor,
          showUnselectedLabels: false,
          selectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(icon: SvgPicture.asset("assets/icons/menu.svg"), activeIcon: SvgPicture.asset("assets/icons/menu.svg", color: Colors.black,) ,label: 'Menu'),
            BottomNavigationBarItem(icon: SvgPicture.asset("assets/icons/home.svg"), activeIcon: SvgPicture.asset("assets/icons/home.svg", color: Colors.black,), label: 'Accueil'),
            BottomNavigationBarItem(icon: SvgPicture.asset("assets/icons/plus.svg"), activeIcon: SvgPicture.asset("assets/icons/plus.svg", color: Colors.black,), label: 'Plus'),
          ],
        ),
      ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}
