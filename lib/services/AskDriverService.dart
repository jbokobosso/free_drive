import 'dart:collection';
import 'dart:convert' as convert;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/models/DriverModel.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/PlacesQueryResponse.dart';
import 'package:free_drive/models/RideModel.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/ExceptionService.dart';
import 'package:free_drive/services/ServiceLocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class AskDriverService {

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CoreService _coreService = getIt.get<CoreService>();
  ExceptionService _exceptionService = getIt.get<ExceptionService>();

  GooglePlace _departureLocation;
  GooglePlace _destinationLocation;
  GooglePlace get departureLocation => _departureLocation;
  GooglePlace get destinationLocation => _destinationLocation;

  setDestinationLocation(GooglePlace newGooglePlace) {
    _destinationLocation = newGooglePlace;
  }

  updateDestinationLocationFromPlaceDetails(String name, String address, LatLng latLng) {
    _destinationLocation.name = name;
    _destinationLocation.address = address;
    _destinationLocation.latLng = latLng;
  }

  updateDestinationLocationOnMapTapped(LatLng newLatLng) {
    _destinationLocation.latLng = newLatLng;
  }

  Future<bool> newRide(RideModel ride) async {
    bool result = false;
    try {
      DocumentReference newRide = await this.firestore.collection(FCN_rides).add(ride.toJSON());
      if(newRide != null)
        result = true;
      else
        result = false;
    } catch (e) {
      result = false;
      this._exceptionService.manageExCeption(e);
    }
    return result;
  }

  Future<List<DriverModel>> loadDrivers() async {
    List<DriverModel> drivers = [];
    QuerySnapshot<Map<String, dynamic>> driversQuerySnap = await firestore.collection(FCN_drivers).get();
    driversQuerySnap.docs.forEach((element) {
      Map<String, dynamic> firebaseJsonData = element.data();
      DriverModel tempDriver = UserModel.driverFromMap(firebaseJsonData);
      tempDriver.userType = EUserType.driver;
      tempDriver.id = element.id;
      drivers.add(tempDriver);
    });
    return drivers;
  }

  queryGooglePlacesAutoComplete(String searchTerm) async {
    String url = "https://maps.googleapis.com/maps/api/place/autocomplete/"
        "json?input=$searchTerm&location=8.6093407,-1.4116933&radius=500000"
        "&strictbounds=true&types=establishment&key=$GMAPS_API_KEY&language=fr";
    var response = await http.get(Uri.tryParse(url));
    if(response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      var predictions = json['predictions'] as List;
      return predictions.map((place) => PlacesAutoComplete.fromJson(place)).toList();
    }
  }

  queryGooglePlaceDetails(String placeId) async {
    String url = "https://maps.googleapis.com/maps/api/place/details/"
        "json?fields=name,formatted_address,geometry"
        "&place_id=$placeId&key=$GMAPS_API_KEY";
    var response = await http.get(Uri.tryParse(url));
    if(response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      Map<String, dynamic> result = json['result'];
      return PlaceDetails.fromJson(result);
    }
  }
}