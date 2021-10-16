import 'package:flutter/foundation.dart';
import 'package:free_drive/models/DriverModel.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/utils/Utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum ERideState {
  pending,
  accepted,
  running,
  done,
  canceled
}

class RideModel {
  String id;
  LatLng departureLocation;
  GooglePlace destinationLocation;
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
      departureLocation: LatLng.fromJson(json['departureLocation']),
      destinationLocation: GooglePlace.fromJSON(json['destinationLocation']),
      departureDate: Utils.timestampToDateTime(json['departureDate']),
      returnDate: Utils.timestampToDateTime(json['returnDate']),
      rideDurationInDays: json['rideDurationInDays'],
      timeStarted: json['timeStarted'] != null ? Utils.timestampToDateTime(json['timeStarted']) : null,
      timeEnded: json['timeEnded'] != null ? Utils.timestampToDateTime(json['timeEnded']) : null,
      driver: UserModel.driverFromMap(json['driver']),
      client: UserModel.clientFromMap(json['client']),
      clientEmail: json['clientEmail'],
      driverEmail: json['driverEmail'],
      rideState: json['rideState'] == 'pending' ? ERideState.pending
          : json['rideState'] == 'running' ? ERideState.running
          : json['rideState'] == 'accepted' ? ERideState.accepted
          : json['rideState'] == 'canceled' ? ERideState.canceled
          : ERideState.done
    );
    return ride;
  }

  Map<String, dynamic> toJSON() {
    return {
      'id' : this.id,
      'departureLocation' : this.departureLocation.toJson(),
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
      'rideState' : this.rideState == ERideState.pending ? "pending"
          : this.rideState == ERideState.running ? "running"
          : this.rideState == ERideState.accepted ? "accepted"
          : this.rideState == ERideState.canceled ? "canceled"
          : "done"
    };
  }

}

class GooglePlace {
  String placeId;
  String name;
  String desc;
  String address;
  LatLng latLng;

  GooglePlace({
    @required this.placeId,
    @required this.name,
    @required this.desc,
    @required this.address,
    @required this.latLng
  });

  Map<String, dynamic> toJSON() {
    return {
      "placeId": this.placeId,
      "name": this.name,
      "desc": this.desc,
      "address": this.address,
      "latLng": this.latLng.toJson()
    };
  }

  static fromJSON(Map<String, dynamic> json) {
    return new GooglePlace(
        placeId: json['placeId'],
        name: json['name'],
        desc: json['desc'],
        address: json['address'],
        latLng: LatLng.fromJson(json['latLng']),
    );
  }


}