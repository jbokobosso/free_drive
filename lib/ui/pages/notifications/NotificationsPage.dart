import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/ERideType.dart';
import 'package:free_drive/models/NotificationModel.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/shared/AppBanner.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:stacked/stacked.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({Key key}) : super(key: key);
  int currentNavigationIndex = 1;
  final double cardTopSpacingScale = 0.2;
  final double contentPaddingScale = 0.07;
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

  heightSpacing() {
    return SizedBox(height: 10.0);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      onModelReady: (model) => model.initEyeAnimation(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(title: 'Notifications'),
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
                color: Theme.of(context).accentColor
            ),
            AppBanner(),
            Positioned(
              height: model.deviceHeight,
              top: model.deviceHeight*this.cardTopSpacingScale,
              child: SizedBox(
                width: model.deviceWidth*0.8,
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) => NotifTile(notif: new NotificationModel(
                    content: "Nous vous invitons à passer à "
                        "l'auto école Adonaï pour votre test"
                        "ce vendredi 14 mai 2021 à 14h30."
                  ),),
                ),
              ),
            )
          ],
        ),
      ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}

class NotifTile extends StatelessWidget {
  NotificationModel notif;
  final double cardWidthScale = 0.8;
  double cancelRideAlertTopRadius = 20.0;
  NotifTile({
    this.notif
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
        builder: (context, model, child) => GestureDetector(
          onTap: () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(this.cancelRideAlertTopRadius))
                ),
                titlePadding: EdgeInsets.all(0.0),
                title: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(this.cancelRideAlertTopRadius))
                  ),
                  width: double.infinity,
                  height: 30.0,
                  child: Align(child: Text("Notification", style: TextStyle(color: Colors.white)), alignment: Alignment.center),
                ),
                content: Text(this.notif.content),
                actions: [
                  TextButton(child: Text('Ok'), onPressed: () => model.cancelActiveRide()),
                ],
              )
          ),
          child: Container(
              margin: EdgeInsets.symmetric(vertical: model.deviceHeight*0.02),
              padding: EdgeInsets.all(15.0),
              width: model.deviceWidth*this.cardWidthScale,
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
              child: Text(this.notif.content)
          ),
        ),
        viewModelBuilder: () => AppViewModel()
    );
  }
}
