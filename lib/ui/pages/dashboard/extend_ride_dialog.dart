import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:stacked/stacked.dart';
import 'package:free_drive/state/AppViewModel.dart';

class ExtendRideDialog extends StatelessWidget {
  final double cancelRideAlertTopRadius;
  int _extendRideDaysCount = 1 ;
  final _extendRideFormKey = GlobalKey<FormState>();
  TextEditingController _extendRideDaysCountController = new TextEditingController();
  ExtendRideDialog({
    Key key,
    @required this.cancelRideAlertTopRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
        builder: (context, model, child) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(this.cancelRideAlertTopRadius))
          ),
          titlePadding: EdgeInsets.all(0.0),
          title: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(this.cancelRideAlertTopRadius))
            ),
            width: double.infinity,
            height: 30.0,
            child: Align(child: Text("Prolonger Course", style: TextStyle(color: Colors.white)), alignment: Alignment.center),
          ),
          content: SizedBox(
            height: model.deviceHeight*0.3,
            child: Form(
              key: _extendRideFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Combien de jours voulez-vous ajouter ?"),
                  TextFormField(
                    controller: this._extendRideDaysCountController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrez le nombre de jours';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: customInputBorder(context),
                      enabledBorder: customInputBorder(context),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(icon: Icon(Icons.remove), onPressed: () {
                        if(this._extendRideDaysCount != 0)
                          this._extendRideDaysCountController.text = (this._extendRideDaysCount--).toString();
                      }),
                      IconButton(icon: Icon(Icons.add), onPressed: () => this._extendRideDaysCountController.text = (this._extendRideDaysCount++).toString()),
                    ],
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(child: Text('Annuler'), onPressed: () => navigatorKey.currentState.pop()),
            TextButton(child: Text('Valider'), onPressed: () => model.extendRide(this._extendRideFormKey, this._extendRideDaysCountController) ),
          ],
        ),
        viewModelBuilder: () => AppViewModel());
  }
}