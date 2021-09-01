import 'package:flutter/foundation.dart';
import 'package:mapbox_search/mapbox_search.dart';

class RideModel {
  String id;
  MapBoxPlace departureLocation;
  MapBoxPlace destinationLocation;
  DateTime departureDate;
  DateTime returnDate;
  int rideDurationInDays;
  DateTime timeStarted;
  DateTime timeEnded;

  RideModel({
    @required this.id,
    @required this.departureLocation,
    @required this.destinationLocation,
    @required this.departureDate,
    @required this.returnDate,
    @required this.rideDurationInDays,
    @required this.timeStarted,
    @required this.timeEnded
  });

  static RideModel fromJSON(Map<String, dynamic> json, String firebaseId) {
    return new RideModel(
        id: firebaseId,
        departureLocation: MapBoxPlace.fromJson(json['departureLocation']),
        destinationLocation: MapBoxPlace.fromJson(json['destinationLocation']),
        departureDate: DateTime.tryParse(json['departureDate']),
        returnDate: DateTime.tryParse(json['returnDate']),
        rideDurationInDays: json['rideDurationInDays'],
        timeStarted: json['timeStarted'] != null ? DateTime.tryParse(json['timeStarted']) : null,
        timeEnded: json['timeEnded'] != null ? DateTime.tryParse(json['timeEnded']) : null
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id' : this.id ?? null,
      'departureLocation' : this.departureLocation.toJson(),
      'destinationLocation' : this.destinationLocation.toJson(),
      'departureDate' : this.departureDate,
      'returnDate' : this.returnDate,
      'rideDurationInDays' : this.rideDurationInDays,
      'timeStarted' : this.timeStarted,
      'timeEnded' : this.timeEnded
    };
  }

}