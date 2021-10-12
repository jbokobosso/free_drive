import 'package:flutter/material.dart';
import 'package:free_drive/ui/pages/ask_driver/AskDriverViewModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class PickPlace extends StatelessWidget {
  Function storeCallback;
  PickPlace(this.storeCallback, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AskDriverViewModel>.reactive(
      onModelReady: (model) => model.initView(),
      builder: (context, model, child) => Scaffold(
          body: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    label: Text('Rechercher un lieu'),
                    icon: Icon(Icons.place)
                ),
              ),
              Expanded(
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: model.defaultLocation,
                  onMapCreated: (GoogleMapController controller) {
                    model.controller.complete(controller);
                  },
                  compassEnabled: true,
                  mapToolbarEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  markers: model.markers,
                  onTap: (LatLng latLng) => model.onTappedMapLocation(latLng),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => model.controllMap(LatLng(7.1232521,0.7204892)),
                    child: Text('Action'),
                  ),
                  ElevatedButton(
                    onPressed: () => this.storeCallback(),
                    child: Text('Choisir Lieu'),
                  ),
                ],
              )
            ],
          ),
        ),
      viewModelBuilder: () => AskDriverViewModel()
    );
  }
}
