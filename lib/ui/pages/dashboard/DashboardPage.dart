import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:free_drive/ui/shared/DashboardCard.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:stacked/stacked.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key key}) : super(key: key);
  int currentNavigationIndex = 1;
  double cardTopSpacingScale = 0.2;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      onModelReady: (model) => model.initEyeAnimation(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(title: 'Tableau de bord'),
        extendBodyBehindAppBar: true,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: model.deviceHeight*0.1,
                  left: model.deviceWidth*0.07,
                  right: model.deviceWidth*0.07
              ),
              width: model.deviceWidth,
              height: model.deviceHeight,
              color: Theme.of(context).accentColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 0, width: 0,),
                  ElevatedButton(
                      style: customButtonStyle(context),
                      onPressed: () => navigatorKey.currentState.pushNamed('/askDriver'),
                      child: Text('Demander un chauffeur', style: TextStyle(fontWeight: FontWeight.bold))
                  ),
                ],
              ),
            ),
            Container(
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
            DashboardCard()
          ],
        ),
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
