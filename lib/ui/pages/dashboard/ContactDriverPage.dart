import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:free_drive/ui/shared/DashboardCard.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:stacked/stacked.dart';

class ContactDriverPage extends StatelessWidget {
  double inputSpacingScale = 0.02;
  double inputHeightScale = 0.08;
  ContactDriverPage({Key key}) : super(key: key);
  int currentNavigationIndex = 1;

  Future<bool> _callNumber() {
    const number = '+22899885825'; //set the number here
    Future<bool> callResult = FlutterPhoneDirectCaller.callNumber(number);
    return callResult;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      onModelReady: (model) => model.initEyeAnimation(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(title: 'Contact'),
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
                  SizedBox(height: model.deviceHeight*0.35),
                  Text('Appelez votre chauffeur', style: Theme.of(context).textTheme.headline1),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(15.0)
                      ),
                      onPressed: () async {
                        var result = await _callNumber();
                        if(result) print("call success");
                        else print("error calling");
                      },
                      child: Icon(Icons.phone, size: model.deviceWidth*0.1)
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff333333),
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(15.0)
                      ),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('SMS'),
                          content: SizedBox(
                            height: model.deviceHeight*0.35,
                            child: Form(
                              child: Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: 'chauffeur',
                                      enabledBorder: customInputBorder(context),
                                      border: customInputBorder(context),
                                    ),
                                  ),
                                  SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                                  TextFormField(
                                    minLines: 3,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: 'message',
                                      enabledBorder: customInputBorder(context),
                                      border: customInputBorder(context),
                                    ),
                                  ),
                                  SizedBox(height: model.deviceHeight*this.inputSpacingScale),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30.0)
                                          )
                                      ),
                                      onPressed: () => navigatorKey.currentState.pushNamed('/afterContact'),
                                      child: Icon(Icons.send)
                                  ),
                                ],
                              ),
                            ),
                          )
                        )
                      ),
                      child: Icon(Icons.message_rounded, size: model.deviceWidth*0.05)
                  ),
                  ElevatedButton(
                      style: customButtonStyle(context),
                      onPressed: () => navigatorKey.currentState.pushNamedAndRemoveUntil("/dashboard", (Route<dynamic> route) => false),
                      child: Text('Poursuivre')
                  )
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
            DashboardCard(),
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
