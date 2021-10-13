import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDetails {
  String name;
  String address;
  LatLng latLng;

  PlaceDetails(this.name, this.address, this.latLng);
  
  static fromJson(Map<String, dynamic> json) {
    return PlaceDetails(
        json['name'],
        json['formatted_address'],
        LatLng(
            json['geometry']['location']['lat'],
            json['geometry']['location']['lng']
        )
    );
  }

}

class PlacesAutoComplete {
   String placeId;
   String description;

   PlacesAutoComplete(this.placeId, this.description);

   static PlacesAutoComplete fromJson(Map<dynamic, dynamic> parsedJson) {
     return PlacesAutoComplete(parsedJson['place_id'], parsedJson['description']);
   }
}