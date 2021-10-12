import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDetailQueryResponse {
  String placeId;
  String longName;
  String shortName;
  LatLng location;

  PlaceDetailQueryResponse(this.placeId, this.longName, this.shortName, this.location);
  
  static fromJson(Map<String, dynamic> json) {
    return PlaceDetailQueryResponse(
        json['place_id'],
        json['address_components'][0]['long_name'],
        json['address_components'][0]['long_name'],
        LatLng(
            json['geometry']['location']['lat'],
            json['geometry']['location']['lng']
        )
    );
  }

}

class PlacesQueryResponse {
   String description;
   String placeId;

   PlacesQueryResponse(this.placeId, this.description);

   static PlacesQueryResponse fromJson(Map<dynamic, dynamic> parsedJson) {
     return PlacesQueryResponse(parsedJson['place_id'], parsedJson['description']);
   }
}