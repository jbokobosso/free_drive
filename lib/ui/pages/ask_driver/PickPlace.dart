import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:free_drive/models/PlacesQueryResponse.dart';
import 'package:free_drive/ui/pages/ask_driver/AskDriverViewModel.dart';
import 'package:free_drive/ui/shared/Button.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class PickPlace extends StatelessWidget {
  Function storeCallback;
  PickPlace(this.storeCallback, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AskDriverViewModel>.reactive(
      onModelReady: (model) => model.initPickPlaceView(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(title: "Choisissez votre destination"),
          body: Column(
            children: [
              TypeAheadField<PlacesAutoComplete>(
                debounceDuration: Duration(milliseconds: 500),
                hideSuggestionsOnKeyboardHide: false,
                textFieldConfiguration: TextFieldConfiguration(
                  controller: model.departureLocationCtrl,
                  autofocus: false,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: model.deviceWidth*0.045, color: Colors.grey),
                      labelText: "Ville, Quartier, Lieu",
                      prefixIcon: Icon(Icons.place, color: Theme.of(context).primaryColor),
                      contentPadding: EdgeInsets.all(0),
                      prefix: Icon(Icons.place),
                      suffixIcon: Icon(Icons.search)
                  ),
                ),
                suggestionsCallback: model.getAutoCompletePlacesSuggestions,
                itemBuilder: (context, PlacesAutoComplete suggestion) => ListTile(
                  title: Text(suggestion.description),
                  // subtitle: Text(suggestion.placeId),
                ),
                onSuggestionSelected: (PlacesAutoComplete selectedSuggestion) {
                  model.onSuggestionSelected(selectedSuggestion);
                },
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  color: Colors.green,
                  child: Text(
                      'Recherchez ou tapez un lieu sur la carte\npuis cliquez sur Confirmer Ma Destination',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    GoogleMap(
                      mapType: MapType.hybrid,
                      initialCameraPosition: model.defaultLocation,
                      onMapCreated: (GoogleMapController controller) {
                        model.googleMapController.complete(controller);
                      },
                      compassEnabled: true,
                      mapToolbarEnabled: true,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      markers: model.markers,
                      onTap: (LatLng latLng) => model.onTappedMapLocation(latLng),
                    ),
                    Button(this.storeCallback, 'Confirmer Ma Destination', isAction: true),
                  ],
                ),
              )
            ],
          ),
        ),
      viewModelBuilder: () => AskDriverViewModel()
    );
  }
}
