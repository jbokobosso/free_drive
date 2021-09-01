import 'package:flutter/foundation.dart';
import 'package:free_drive/models/DriverModel.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/models/EUserType.dart';

class RideModel {
  String id;
  Place departureLocation;
  Place destinationLocation;
  DateTime departureDate;
  DateTime returnDate;
  int rideDurationInDays;
  DateTime timeStarted;
  DateTime timeEnded;
  DriverModel driver;

  RideModel({
    @required this.id,
    @required this.departureLocation,
    @required this.destinationLocation,
    @required this.departureDate,
    @required this.returnDate,
    @required this.rideDurationInDays,
    @required this.timeStarted,
    @required this.timeEnded,
    @required this.driver
  });

  static RideModel fromJSON(Map<String, dynamic> json, String firebaseId) {
    return new RideModel(
        id: firebaseId,
        departureLocation: Place.fromJSON(json['departureLocation']),
        destinationLocation: Place.fromJSON(json['destinationLocation']),
        departureDate: DateTime.tryParse(json['departureDate']),
        returnDate: DateTime.tryParse(json['returnDate']),
        rideDurationInDays: json['rideDurationInDays'],
        timeStarted: json['timeStarted'] != null ? DateTime.tryParse(json['timeStarted']) : null,
        timeEnded: json['timeEnded'] != null ? DateTime.tryParse(json['timeEnded']) : null,
        driver: UserModel.driverFromMapOld(json['driver'])
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id' : this.id,
      'departureLocation' : this.departureLocation.toJSON(),
      'destinationLocation' : this.destinationLocation.toJSON(),
      'departureDate' : this.departureDate,
      'returnDate' : this.returnDate,
      'rideDurationInDays' : this.rideDurationInDays,
      'timeStarted' : this.timeStarted,
      'timeEnded' : this.timeEnded,
      'driver': this.driver.toMap(userType: EUserType.driver)
    };
  }

}

class Place {
  double latitude;
  double longitude;
  String shortName;
  String longName;

  Place({@required this.latitude, @required this.longitude, @required this.shortName, @required this.longName});

  Map<String, dynamic> toJSON() {
    return {
      "latitude": this.latitude,
      "longitude": this.longitude,
      "shortName": this.shortName,
      "longName": this.longName
    };
  }

  static fromJSON(Map<String, dynamic> json) {
    return new Place(latitude: json['latitude'], longitude: json['longitude'], shortName: json['shortName'], longName: json['longName']);
  }


}