import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/ERideType.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:stacked/stacked.dart';

class AskDriverPage extends StatelessWidget {
  AskDriverPage({Key key}) : super(key: key);
  int currentNavigationIndex = 1;
  double cardTopSpacingScale = 0.2;
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
              color: Theme.of(context).accentColor
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
            Positioned(
              top: model.deviceHeight*this.cardTopSpacingScale,
              child: Container(
                width: model.deviceWidth*0.7,
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
                  child: Form(
                    key: _askDriverFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButtonFormField<ERideType>(
                          onChanged: (ERideType newValue) {
                            this.chosenRide = newValue;
                            model.notifyListeners();
                          },
                          value: this.chosenRide,
                          decoration: InputDecoration(
                            enabledBorder: customInputBorder(context),
                            border: customInputBorder(context),
                            contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                          ),
                          items: [
                            DropdownMenuItem(child: Text('Type de course', style: TextStyle(color: Colors.grey),), value: ERideType.hint),
                            DropdownMenuItem(child: Text('Course en ville'), value: ERideType.ride),
                            DropdownMenuItem(child: Text('Voyage'), value: ERideType.trip),
                          ],
                        ),
                        heightSpacing(),
                        TextFormField(
                          decoration: InputDecoration(
                            enabled: false,
                            labelText: 'Lieu de départ',
                            prefixIcon: Icon(Icons.place, color: Theme.of(context).primaryColor),
                            contentPadding: EdgeInsets.all(0),
                            enabledBorder: customInputBorder(context),
                            border: customInputBorder(context),
                            disabledBorder: customInputBorder(context),
                          )
                        ),
                        heightSpacing(),
                        TextFormField(
                            decoration: InputDecoration(
                              enabled: false,
                              labelText: "Lieu d'arrivvée",
                              prefixIcon: Icon(Icons.place, color: Theme.of(context).primaryColor),
                              contentPadding: EdgeInsets.all(0),
                              enabledBorder: customInputBorder(context),
                              border: customInputBorder(context),
                              disabledBorder: customInputBorder(context),
                            )
                        ),
                        this.chosenRide == ERideType.trip
                        ? Column(
                            children: [
                              heightSpacing(),
                              GestureDetector(
                                onTap: () async {
                                  DateTime pickedDate = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(Duration(days: 365)),
                                    initialDate: DateTime.now(),
                                    currentDate: DateTime.now(),
                                  );
                                  this.departureDate = pickedDate;
                                  this.departureDateController.text = new CoreService().formatDate(pickedDate);
                                },
                                child: TextFormField(
                                    controller: this.departureDateController,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      labelText: "Date de départ",
                                      prefixIcon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                                      contentPadding: EdgeInsets.all(0),
                                      enabledBorder: customInputBorder(context),
                                      border: customInputBorder(context),
                                      disabledBorder: customInputBorder(context),
                                    )
                                ),
                              ),
                              heightSpacing(),
                              GestureDetector(
                                onTap: () async {
                                  DateTime pickedDate = await showDatePicker(
                                    context: context,
                                    firstDate: this.departureDate.add(Duration(days: 1)),
                                    lastDate: DateTime.now().add(Duration(days: 365)),
                                    initialDate: this.departureDate.add(Duration(days: 1)),
                                    currentDate: DateTime.now(),
                                  );
                                  this.returnDate = pickedDate;
                                  this.returnDateController.text = new CoreService().formatDate(pickedDate);
                                  Duration rideDuration = this.returnDate.difference(this.departureDate);
                                  this.rideDurationController.text = "${rideDuration.inDays.toString()} Jours";
                                },
                                child: TextFormField(
                                    controller: this.returnDateController,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      labelText: "Date de retour",
                                      prefixIcon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                                      contentPadding: EdgeInsets.all(0),
                                      enabledBorder: customInputBorder(context),
                                      border: customInputBorder(context),
                                      disabledBorder: customInputBorder(context),
                                    )
                                ),
                              ),
                            ],
                        )
                        : this.chosenRide == ERideType.ride ? Column(
                          children: [
                            heightSpacing(),
                            GestureDetector(
                              onTap: () async {
                                TimeOfDay pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay(hour: 0, minute: 0),
                                  cancelText: 'Annuler',
                                  context: context
                                );
                                this.departureTime = pickedTime;
                                this.departureTimeController.text = new CoreService().formatTime(pickedTime);
                              },
                              child: TextFormField(
                                  controller: this.departureTimeController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    labelText: "Heure de départ",
                                    prefixIcon: Icon(Icons.timelapse, color: Theme.of(context).primaryColor),
                                    contentPadding: EdgeInsets.all(0),
                                    enabledBorder: customInputBorder(context),
                                    border: customInputBorder(context),
                                    disabledBorder: customInputBorder(context),
                                  )
                              ),
                            ),
                            heightSpacing(),
                            GestureDetector(
                              onTap: () async {
                                TimeOfDay pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(hour: 0, minute: 0),
                                  cancelText: 'Annuler',
                                );
                                this.returnTime = pickedTime;
                                this.returnTimeController.text = new CoreService().formatTime(pickedTime);
                                var rideDuration = this.returnTime.hour - this.departureTime.hour;
                                this.rideDurationController.text = "${rideDuration.toString()} Heures";
                              },
                              child: TextFormField(
                                  controller: this.returnTimeController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    labelText: "Heure de retour",
                                    prefixIcon: Icon(Icons.timelapse, color: Theme.of(context).primaryColor),
                                    contentPadding: EdgeInsets.all(0),
                                    enabledBorder: customInputBorder(context),
                                    border: customInputBorder(context),
                                    disabledBorder: customInputBorder(context),
                                  )
                              ),
                            ),
                          ],
                        )
                        : Container(height: 0, width: 0,),
                        heightSpacing(),
                        TextFormField(
                          controller: this.rideDurationController,
                            decoration: InputDecoration(
                              enabled: false,
                              labelText: "Durée de la course",
                              prefixIcon: Icon(Icons.hourglass_bottom_outlined, color: Theme.of(context).primaryColor),
                              contentPadding: EdgeInsets.all(0),
                              enabledBorder: customInputBorder(context),
                              border: customInputBorder(context),
                              disabledBorder: customInputBorder(context),
                            )
                        ),
                        heightSpacing(),
                        this.chosenRide != ERideType.hint
                            ? ElevatedButton(
                                style: customButtonStyle(context),
                                child: Text('Demander', style: TextStyle(fontWeight: FontWeight.bold)),
                                onPressed: () => navigatorKey.currentState.pushNamed("/yourDriver"),
                              )
                            : Container(height: 0, width: 0,)
                      ],
                    ),
                  ),
                ),
              ),
            )
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
