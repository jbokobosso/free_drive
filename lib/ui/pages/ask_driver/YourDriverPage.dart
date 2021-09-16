import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/ERideType.dart';
import 'package:free_drive/models/RideModel.dart';
import 'package:free_drive/ui/pages/ask_driver/AskDriverViewModel.dart';
import 'package:free_drive/ui/shared/AppBanner.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:stacked/stacked.dart';

class YourDriverPage extends StatelessWidget {
  YourDriverPage({Key key}) : super(key: key);
  int currentNavigationIndex = 1;
  double cardTopSpacingScale = 0.2;
  double cardWidthScale = 0.8;
  double cardHeightScale = 0.3;
  ERideType chosenRide = ERideType.hint;
  var _askDriverFormKey = GlobalKey<FormState>();
  TextEditingController rideDurationController = new TextEditingController();
  TextEditingController departureDateController = new TextEditingController();
  TextEditingController returnDateController = new TextEditingController();
  TextEditingController departureTimeController = new TextEditingController();
  TextEditingController returnTimeController = new TextEditingController();
  DateTime departureDate;
  DateTime returnDate;
  TimeOfDay departureTime;
  TimeOfDay returnTime;
  RideModel ride;

  heightSpacing() {
    return SizedBox(height: 10.0);
  }

  @override
  Widget build(BuildContext context) {

    this.ride = ModalRoute.of(context).settings.arguments;

    return ViewModelBuilder<AskDriverViewModel>.reactive(
      onModelReady: (model) => model.initEyeAnimation(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(title: 'Demander un chauffeur'),
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
                      style: customButtonStyle(context, isAction: true),
                      onPressed: () => navigatorKey.currentState.pushNamed("/contactDriver", arguments: this.ride),
                      child: Text('Contactez', style: TextStyle(fontWeight: FontWeight.bold))
                  ),
                ],
              ),
            ),
            AppBanner(),
            Positioned(
              top: model.deviceHeight*this.cardTopSpacingScale,
              child: Container(
                width: model.deviceWidth*this.cardWidthScale,
                height: model.deviceHeight*this.cardHeightScale,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ListTile(
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage("assets/img/person.jpg"), fit: BoxFit.cover),
                            shape: BoxShape.circle,
                            border: Border.all(color: Theme.of(context).primaryColor)
                          ),
                        ),
                        title: Text(this.ride.driver.displayName, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${this.ride.driver.phoneNumber}\n\n ${this.ride.driver.address}"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: Theme.of(context).primaryColor),
                          Icon(Icons.star, color: Theme.of(context).primaryColor),
                          Icon(Icons.star, color: Theme.of(context).primaryColor),
                          Icon(Icons.star, color: Theme.of(context).primaryColor),
                          Icon(Icons.star_border, color: Theme.of(context).primaryColor),
                        ],
                      )
                    ],
                  )
                ),
              ),
            )
          ],
        )
      ),
      viewModelBuilder: () => AskDriverViewModel(),
    );
  }
}
