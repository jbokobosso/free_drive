import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/DriverModel.dart';
import 'package:free_drive/models/EAutocompleteType.dart';
import 'package:free_drive/models/EDialogType.dart';
import 'package:free_drive/models/ERideType.dart';
import 'package:free_drive/services/AskDriverService.dart';
import 'package:free_drive/services/ContactDriverService.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/GetIt.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

class AskDriverViewModel extends BaseViewModel {

  CoreService coreService = getIt.get<CoreService>();
  AskDriverService askDriverService = getIt.get<AskDriverService>();
  ContactDriverService contactDriverService = getIt.get<ContactDriverService>();
  Artboard eyeArtboard;
  Artboard logoArtboard;
  RiveAnimationController eyeAnimationController;
  RiveAnimationController logoAnimationController;

  var smsFormKey = GlobalKey<FormState>();
  var departureFormKey = GlobalKey<FormState>();
  TextEditingController departureLocationCtrl = new TextEditingController();
  TextEditingController destinationLocationCtrl = new TextEditingController();
  TextEditingController smsMessageCtrl = new TextEditingController();
  ERideType chosenRide = ERideType.ride;
  var durationFormKey = GlobalKey<FormState>();
  TextEditingController rideDurationController = new TextEditingController();
  TextEditingController departureDateController = new TextEditingController();
  TextEditingController returnDateController = new TextEditingController();
  TextEditingController departureTimeController = new TextEditingController();
  TextEditingController returnTimeController = new TextEditingController();
  DateTime departureDate;
  DateTime returnDate;
  TimeOfDay departureTime;
  TimeOfDay returnTime;
  bool returnIsSameDay = false;

  double get deviceWidth => this.coreService.deviceWidth;
  double get deviceHeight => this.coreService.deviceHeight;

  bool contactedDriver = false;

  List<MapBoxPlace> places = [];

  var placesSearch = PlacesSearch(
    apiKey: MAPBOX_TOKEN,
    limit: PLACES_SEARCH_RESULT_LIMIT,
  );

  initView() {
    this.smsFormKey = new GlobalKey<FormState>();
    this.initEyeAnimation();
  }

  initEyeAnimation() {
    rootBundle.load('assets/rive/close_open_eye.riv')
        .then(
          (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(eyeAnimationController = SimpleAnimation('close'));
        eyeArtboard = artboard;
        notifyListeners();
        eyeAnimationController.isActive = true;
        notifyListeners();
      },
    );
  }

  initTurnLogoAnimation() {
    rootBundle.load('assets/rive/logo.riv')
        .then(
          (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(logoAnimationController = SimpleAnimation('turn'));
        logoArtboard = artboard;
        notifyListeners();
        logoAnimationController.isActive = true;
        notifyListeners();
      },
    );
  }

  askDriver() async {
    bool departureValid = this.departureFormKey.currentState.validate();
    bool durationValid = this.durationFormKey.currentState.validate();
    if(!departureValid || !durationValid)
      return;
    setBusy(true);
    List<DriverModel> drivers = await this.askDriverService.loadDrivers();
    if(drivers != null) {
      setBusy(false);
      showDialog(
          context: navigatorKey.currentContext,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: Text("Choisissez votre chauffeur"),
            content: ListView.builder(
              itemCount: drivers.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () => navigatorKey.currentState.pushNamed("/yourDriver", arguments: drivers[index]),
                title: Text(drivers[index].displayName),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.person, color: Colors.white,),
                ),
              )
            ),
            actions: [
              TextButton(
                child: Text("Fermer"),
                onPressed: () => navigatorKey.currentState.pop(),
              )
            ],
          ));
    } else {
      this.coreService.showToastMessage("Base de données vide. Revenez plus tard...");
    }

  }

  callDriver(String phoneNumber) async {
    var callSucceded = await this.contactDriverService.callDriver(phoneNumber);
    if(callSucceded) contactedDriver = true;
    notifyListeners();
  }

  textDriver(String phoneNumber, String message) async {
    bool textSucceded = await this.contactDriverService.textDriver(message, [phoneNumber]);
    if(textSucceded) this.contactedDriver = true;
    notifyListeners();
  }

  Future<List<MapBoxPlace>> getPlaces(String searchText) async {
    return await placesSearch.getPlaces(searchText);
  }

  void computeAndSetRideDuration() {
    Duration rideDuration = this.returnDate.difference(this.departureDate);
    this.rideDurationController.text = "${rideDuration.inDays.toString()} Jours";
  }
  
  handleCheckbox(bool newValue) {
    this.returnIsSameDay = newValue;
    if(newValue == true) { // if checked return same date
      this.returnDate = this.departureDate;
      this.returnDateController.text = this.coreService.formatDate(this.departureDate);
      this.computeAndSetRideDuration();
    }
    this.notifyListeners();
  }
  
  handleDepartureDateInput() async {
    DateTime pickedDate = await showDatePicker(
      context: navigatorKey.currentContext,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
    );
    this.departureDate = pickedDate;
    this.departureDateController.text = this.coreService.formatDate(pickedDate);
    this.notifyListeners();
  }

  handleReturnDateInput() async {
    if(this.returnIsSameDay) return;
    if(this.departureDate == null) {
      this.coreService.showDialogBox("ATTENTION", "Veuillez sélectionner la date de départ d'abord", dialogType: EDialogType.warning);
      return;
    }
    DateTime pickedDate = await showDatePicker(
      context: navigatorKey.currentContext,
      firstDate: this.departureDate,
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDate: this.departureDate.add(Duration(days: 1)),
      currentDate: DateTime.now(),
    );
    this.returnDate = pickedDate;
    this.returnDateController.text = this.coreService.formatDate(pickedDate);
    this.computeAndSetRideDuration();
  }

  handleAutocompleteInputs(EAutocompleteType autocompleteType, MapBoxPlace selectedSuggestion) {
    switch(autocompleteType) {
      case EAutocompleteType.departure:
        this.departureLocationCtrl.text = selectedSuggestion.placeName;
        break;
      case EAutocompleteType.returnback:
        this.destinationLocationCtrl.text = selectedSuggestion.placeName;
        break;
    }
  }

}