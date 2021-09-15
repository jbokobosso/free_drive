import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:free_drive/models/DriverModel.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/utils/Utils.dart';

enum ERideState {
  pending,
  running,
  done
}

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
  UserModel client;
  String clientEmail;
  String driverEmail;
  ERideState rideState;

  RideModel({
    @required this.id,
    @required this.departureLocation,
    @required this.destinationLocation,
    @required this.departureDate,
    @required this.returnDate,
    @required this.rideDurationInDays,
    @required this.timeStarted,
    @required this.timeEnded,
    @required this.driver,
    @required this.client,
    @required this.clientEmail,
    @required this.driverEmail,
    @required this.rideState
  });

  static RideModel fromJSON(Map<String, dynamic> json, String firebaseId) {
    RideModel ride = new RideModel(
      id: firebaseId,
      departureLocation: Place.fromJSON(json['departureLocation']),
      destinationLocation: Place.fromJSON(json['destinationLocation']),
      departureDate: Utils.timestampToDateTime(json['departureDate']),
      returnDate: Utils.timestampToDateTime(json['returnDate']),
      rideDurationInDays: json['rideDurationInDays'],
      timeStarted: json['timeStarted'] != null ? Utils.timestampToDateTime(json['timeStarted']) : null,
      timeEnded: json['timeEnded'] != null ? Utils.timestampToDateTime(json['timeEnded']) : null,
      driver: UserModel.driverFromMapOld(json['driver']),
      client: UserModel.clientFromFirebase(json['client']),
      clientEmail: json['clientEmail'],
      driverEmail: json['driverEmail'],
      rideState: json['rideState'] == 'pending' ? ERideState.pending : json['rideState'] == 'running' ? ERideState.running : ERideState.done
    );
    return ride;
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
      'driver': this.driver != null ? this.driver.toMap(userType: EUserType.driver) : null,
      'client': this.client != null ? this.client.toMap(userType: EUserType.client) : null,
      'clientEmail': this.clientEmail,
      'driverEmail': this.driverEmail,
      'rideState' : this.rideState == ERideState.pending ? "pending" : this.rideState == ERideState.running ? "running" : "done"
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