
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/DriverModel.dart';
import 'package:free_drive/models/EDialogType.dart';
import 'package:free_drive/models/ERideType.dart';
import 'package:free_drive/models/PlacesQueryResponse.dart';
import 'package:free_drive/models/RideModel.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/services/AskDriverService.dart';
import 'package:free_drive/services/AuthService.dart';
import 'package:free_drive/services/ContactDriverService.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/ServiceLocator.dart';
import 'package:free_drive/utils/Utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

class AskDriverViewModel extends BaseViewModel {

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CoreService coreService = getIt.get<CoreService>();
  AuthService _authService = getIt.get<AuthService>();
  AskDriverService askDriverService = getIt.get<AskDriverService>();
  ContactDriverService contactDriverService = getIt.get<ContactDriverService>();
  Artboard eyeArtboard;
  Artboard logoArtboard;
  RiveAnimationController eyeAnimationController;
  RiveAnimationController logoAnimationController;

  UserModel loggedUser;

  TextEditingController smsMessageCtrl = new TextEditingController();
  ERideType chosenRide = ERideType.ride;
  var smsFormKey = GlobalKey<FormState>();
  var durationFormKey = GlobalKey<FormState>();
  TextEditingController departureLocationCtrl = new TextEditingController();
  TextEditingController destinationLocationCtrl = new TextEditingController();
  TextEditingController rideDurationController = new TextEditingController();
  TextEditingController departureDateController = new TextEditingController();
  TextEditingController returnDateController = new TextEditingController();
  TextEditingController departureTimeController = new TextEditingController();
  TextEditingController returnTimeController = new TextEditingController();
  DateTime departureDate;
  DateTime returnDate;
  TimeOfDay departureTime;
  TimeOfDay returnTime;
  int rideDurationInDays;
  bool returnIsSameDay = false;

  double get deviceWidth => this.coreService.deviceWidth;
  double get deviceHeight => this.coreService.deviceHeight;

  bool contactedDriver = false;

  CameraPosition defaultLocation;
  var markers;
  Completer<GoogleMapController> googleMapController = Completer();

  initAskDriverView() {
    this.setDefaultLocation();
    this.setMarker(
      latLng: LatLng(this.coreService.locationData.latitude, this.coreService.locationData.longitude),
      markerId: "${this.coreService.locationData.latitude},${this.coreService.locationData.longitude}"
    );
    this.loadLoggedUser();
    this.smsFormKey = new GlobalKey<FormState>();
    this.initEyeAnimation();
    // this.requestUserLocation();
    notifyListeners();
  }

  initPickPlaceView() {
    this.setDefaultLocation();
    this.setMarker(
      latLng: LatLng(this.coreService.locationData.latitude, this.coreService.locationData.longitude),
      markerId: "${this.coreService.locationData.latitude},${this.coreService.locationData.longitude}"
    );
    this.loadLoggedUser();
    this.smsFormKey = new GlobalKey<FormState>();
    this.initEyeAnimation();
    // this.requestUserLocation();
    notifyListeners();
  }

  Future<void> loadLoggedUser() async {
    this.loggedUser = await this._authService.getLoggedUser();
    if(loggedUser != null)
      this.coreService.showToastMessage("Utilisateur chargé !");
    else
      this.coreService.showToastMessage("Erreur chargement utilisateur");
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
    setBusy(true);
    bool departureValid = this.departureLocationCtrl.text != "" && this.departureLocationCtrl.text != "";
    bool durationValid = this.durationFormKey.currentState.validate();
    if(!departureValid || !durationValid) {
      this.coreService.showDialogBox("Formulaire incomplet", "Veuillez entrer toutes les informations demandées.", dialogType: EDialogType.info); // Si le formulaire est invalide
      setBusy(false);
      return;
    }
    RideModel ride = await this.buildRideModel(); // Constituer les données de la course
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
                onTap: () {
                  ride.driver = drivers[index];
                  ride.driverEmail = drivers[index].email;
                  navigatorKey.currentState.pushNamed("/yourDriver", arguments: ride);
                },
                title: Text(drivers[index].displayName),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.person, color: Colors.white,),
                ),
              )
            ),
            actions: [
              TextButton(
                child: Text("Annuler"),
                onPressed: () => navigatorKey.currentState.pop(),
              )
            ],
          ));
    } else {
      setBusy(false);
      notifyListeners();
      this.coreService.showDialogBox("Aucun Chauffeur", "Base de données vide, nous n'avons pas de chauffeur pour le moment. Revenez plus tard...");
    }

  }

  Future<RideModel> buildRideModel() async {
    RideModel ride = new RideModel(
      id: null,
      departureLocation: this.askDriverService.departureLocation,
      destinationLocation: this.askDriverService.destinationLocation,
      departureDate: this.departureDate,
      returnDate: this.returnDate,
      rideDurationInDays: this.rideDurationInDays,
      timeStarted: null,
      timeEnded: null,
      client: this.loggedUser,
      clientEmail: this._firebaseAuth.currentUser.email,
      rideState: ERideState.pending
    );
    return ride;
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

  void computeAndSetRideDuration() {
    Duration rideDuration = this.returnDate.difference(this.departureDate);
    this.rideDurationInDays = rideDuration.inDays;
    this.rideDurationController.text = "${rideDuration.inDays.toString()} Jours";
  }
  
  handleCheckbox(bool newValue) {
    this.returnIsSameDay = newValue;
    if(newValue == true) { // if checked return same date
      this.returnDate = this.departureDate;
      this.returnDateController.text = this.coreService.formatDateToHuman(this.departureDate);
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
    this.departureDateController.text = this.coreService.formatDateToHuman(pickedDate);
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
    this.returnDateController.text = this.coreService.formatDateToHuman(pickedDate);
    this.computeAndSetRideDuration();
  }

  newRide(RideModel ride) async {
    setBusy(true);
    bool success = await this.askDriverService.newRide(ride);
    setBusy(false);
    if(success)
      navigatorKey.currentState.pushNamedAndRemoveUntil("/dashboard", (Route<dynamic> route) => false);
  }

  setDefaultLocation() {
    defaultLocation = CameraPosition(
      target: LatLng(this.coreService.locationData.latitude, this.coreService.locationData.longitude),
      zoom: 14.4746,
    );
  }

  setMarker({LatLng latLng, String markerId}) async {
    this.askDriverService.setDepartureLocation(latLng);
    this.markers = <Marker>{
      Marker(
          icon: BitmapDescriptor.defaultMarker,
          position: latLng,
          markerId: MarkerId(markerId),
          visible: true
      )
    };
  }

  onTappedMapLocation(LatLng newLatLng) async {
    this.askDriverService.setDestinationLocation(GooglePlace(latLng: newLatLng, desc: "${newLatLng.latitude},${newLatLng.longitude}"));
    GoogleMapController googleMapController = await this.googleMapController.future;
    googleMapController.animateCamera(CameraUpdate.newLatLng(newLatLng));
    this.setMarker(latLng: newLatLng, markerId: newLatLng.toString());
    notifyListeners();
    Utils.showToast('Tappez Maintenant sur Confirmer Ma Destination');
  }

  setDepartureTextField() {
    navigatorKey.currentState.pop(); // close gmaps modal
    this.departureLocationCtrl.text = 'Ma Position';
    notifyListeners();
  }

  setDestinationTextField() {
    navigatorKey.currentState.pop(); // close gmaps modal
    this.destinationLocationCtrl.text = this.askDriverService.destinationLocation.desc;
    notifyListeners();
  }

  Future<List<PlacesAutoComplete>> getAutoCompletePlacesSuggestions(String searchTerm) async {
    if(searchTerm.isNotEmpty) {
      return await this.askDriverService.queryGooglePlacesAutoComplete(searchTerm);
    } else return [];
  }

  onSuggestionSelected(PlacesAutoComplete selectedSuggestion) async {
    GooglePlace newGooglePlace = GooglePlace(placeId: selectedSuggestion.placeId, desc: selectedSuggestion.description);
    this.askDriverService.setDestinationLocation(newGooglePlace);
    PlaceDetails placeDetails = await this.askDriverService.queryGooglePlaceDetails(selectedSuggestion.placeId);
    var _gmapsController = await this.googleMapController.future;
    _gmapsController.animateCamera(CameraUpdate.newLatLng(placeDetails.latLng)); // animate map
    this.setMarker(latLng: placeDetails.latLng, markerId: placeDetails.latLng.toString()); // set marker
    this.askDriverService.updateDestinationLocationFromPlaceDetails(placeDetails.name, placeDetails.address, placeDetails.latLng);
    notifyListeners();
  }

}