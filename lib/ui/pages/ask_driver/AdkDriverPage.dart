import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:free_drive/models/ERideType.dart';
import 'package:free_drive/ui/pages/ask_driver/AskDriverViewModel.dart';
import 'package:free_drive/ui/pages/ask_driver/AutoCompleteInput.dart';
import 'package:free_drive/ui/shared/AppBanner.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:free_drive/ui/shared/Loading.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:stacked/stacked.dart';

class AskDriverPage extends StatelessWidget {
  AskDriverPage({Key key}) : super(key: key);
  int currentNavigationIndex = 1;
  final double cardTopSpacingScale = 0.2;
  final double contentPaddingScale = 0.07;
  final double cardWidthScale = 0.8;

  heightSpacing() {
    return SizedBox(height: 10.0);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AskDriverViewModel>.reactive(
      onModelReady: (model) => model.initView(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(title: 'Demander un chauffeur'),
        extendBodyBehindAppBar: true,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: model.coreService.deviceHeight*0.1,
                  left: model.coreService.deviceWidth*0.07,
                  right: model.coreService.deviceWidth*0.07
              ),
              width: model.coreService.deviceWidth,
              height: model.coreService.deviceHeight,
              color: Theme.of(context).accentColor
            ),
            AppBanner(),
            Positioned(
              top: model.coreService.deviceHeight*this.cardTopSpacingScale,
              child: Container(
                width: model.coreService.deviceWidth*this.cardWidthScale,
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
                    children: [
                      Form(
                        key: model.departureFormKey,
                        child: Column(
                          children: [
                            heightSpacing(),
                            AutoCompleteInput(model.departureLocationCtrl, "Lieu de départ"),
                            heightSpacing(),
                            AutoCompleteInput(model.destinationLocationCtrl, "Lieu d'arrivée"),
                          ],
                        ),
                      ),
                      Form(
                        key: model.durationFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // DropdownButtonFormField<ERideType>(
                            //   onChanged: (ERideType newValue) {
                            //     model.chosenRide = newValue;
                            //     model.notifyListeners();
                            //   },
                            //   value: model.chosenRide,
                            //   decoration: InputDecoration(
                            //     enabledBorder: customInputBorder(context),
                            //     border: customInputBorder(context),
                            //     contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                            //   ),
                            //   items: [
                            //     DropdownMenuItem(child: Text('Type de course', style: TextStyle(color: Colors.grey),), value: ERideType.hint),
                            //     DropdownMenuItem(child: Text('Course en ville'), value: ERideType.ride),
                            //     DropdownMenuItem(child: Text('Voyage'), value: ERideType.trip),
                            //   ],
                            // ),
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
                                model.departureDate = pickedDate;
                                model.departureDateController.text = model.coreService.formatDate(pickedDate);
                              },
                              child: TextFormField(
                                  controller: model.departureDateController,
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
                                  firstDate: model.departureDate.add(Duration(days: 1)),
                                  lastDate: DateTime.now().add(Duration(days: 365)),
                                  initialDate: model.departureDate.add(Duration(days: 1)),
                                  currentDate: DateTime.now(),
                                );
                                model.returnDate = pickedDate;
                                model.returnDateController.text = model.coreService.formatDate(pickedDate);
                                Duration rideDuration = model.returnDate.difference(model.departureDate);
                                model.rideDurationController.text = "${rideDuration.inDays.toString()} Jours";
                              },
                              child: TextFormField(
                                  controller: model.returnDateController,
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
                            // Column(
                            //   children: [
                            //     heightSpacing(),
                            //     GestureDetector(
                            //       onTap: () async {
                            //         TimeOfDay pickedTime = await showTimePicker(
                            //           initialTime: TimeOfDay(hour: 0, minute: 0),
                            //           cancelText: 'Annuler',
                            //           context: context
                            //         );
                            //         model.departureTime = pickedTime;
                            //         model.departureTimeController.text = model.coreService.formatTime(pickedTime);
                            //       },
                            //       child: TextFormField(
                            //           controller: model.departureTimeController,
                            //           enabled: false,
                            //           decoration: InputDecoration(
                            //             labelText: "Heure de départ",
                            //             prefixIcon: Icon(Icons.timelapse, color: Theme.of(context).primaryColor),
                            //             contentPadding: EdgeInsets.all(0),
                            //             enabledBorder: customInputBorder(context),
                            //             border: customInputBorder(context),
                            //             disabledBorder: customInputBorder(context),
                            //           )
                            //       ),
                            //     ),
                            //     heightSpacing(),
                            //     GestureDetector(
                            //       onTap: () async {
                            //         TimeOfDay pickedTime = await showTimePicker(
                            //           context: context,
                            //           initialTime: TimeOfDay(hour: 0, minute: 0),
                            //           cancelText: 'Annuler',
                            //         );
                            //         model.returnTime = pickedTime;
                            //         model.returnTimeController.text = model.coreService.formatTime(pickedTime);
                            //         var rideDuration = model.returnTime.hour - model.departureTime.hour;
                            //         model.rideDurationController.text = "${rideDuration.toString()} Heures";
                            //       },
                            //       child: TextFormField(
                            //           controller: model.returnTimeController,
                            //           enabled: false,
                            //           decoration: InputDecoration(
                            //             labelText: "Heure de retour",
                            //             prefixIcon: Icon(Icons.timelapse, color: Theme.of(context).primaryColor),
                            //             contentPadding: EdgeInsets.all(0),
                            //             enabledBorder: customInputBorder(context),
                            //             border: customInputBorder(context),
                            //             disabledBorder: customInputBorder(context),
                            //           )
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            heightSpacing(),
                            TextFormField(
                              controller: model.rideDurationController,
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
                            ElevatedButton(
                              style: customButtonStyle(context),
                              child: Text('Demander', style: TextStyle(fontWeight: FontWeight.bold)),
                              onPressed: () => model.askDriver(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            model.isBusy ? Loading() : Container(height: 0, width: 0)
          ],
        )
      ),
      viewModelBuilder: () => AskDriverViewModel(),
    );
  }
}
