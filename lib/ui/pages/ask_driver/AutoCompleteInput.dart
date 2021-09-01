import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:free_drive/ui/pages/ask_driver/AskDriverViewModel.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:stacked/stacked.dart';

class AutoCompleteInput extends StatelessWidget {
  TextEditingController controller;
  String inputLabel;
  AutoCompleteInput(this.controller, this.inputLabel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AskDriverViewModel>.reactive(
      builder: (context, model, child) => TypeAheadField<MapBoxPlace>(
        hideSuggestionsOnKeyboardHide: false,
        textFieldConfiguration: TextFieldConfiguration(
            controller: model.departureLocationCtrl,
            autofocus: false,
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: model.deviceWidth*0.045, color: Colors.grey),
              labelText: this.inputLabel,
              prefixIcon: Icon(Icons.place, color: Theme.of(context).primaryColor),
              contentPadding: EdgeInsets.all(0),
              enabledBorder: customInputBorder(context),
              border: customInputBorder(context),
              disabledBorder: customInputBorder(context),
            )
        ),
        suggestionsCallback: model.getPlaces,
        itemBuilder: (context, MapBoxPlace suggestion) => ListTile(
          title: Text(suggestion.text),
          subtitle: Text(suggestion.placeName),
        ),
        onSuggestionSelected: (MapBoxPlace selectedSuggestion) {
          this.controller.text = selectedSuggestion.placeName;
        },
      ),
      viewModelBuilder: () => new AskDriverViewModel()
    );
  }
}
