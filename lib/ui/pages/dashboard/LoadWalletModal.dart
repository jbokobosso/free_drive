import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/models/EPaymentMethod.dart';
import 'package:free_drive/ui/pages/dashboard/LoadWalletViewModel.dart';
import 'package:free_drive/ui/shared/Button.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:free_drive/utils/Utils.dart';
import 'package:stacked/stacked.dart';

class LoadWalletModal extends StatelessWidget {
  LoadWalletModal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoadWalletViewModel>.reactive(
      viewModelBuilder: () => LoadWalletViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(title:'Charger Portefeuille'),
        body: AlertDialog(
          title: Text("Charger Portefeuille"),
          content: SizedBox(
            height: Utils.deviceHeight*0.5,
            child: Form(
              key: model.loadWalletFormKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: model.amountCtrl,
                    decoration: customInputDecoration(context, label: 'Montant'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if(value.isEmpty) return "Montant requis";
                      if(double.parse(value) <= MINIMUM_WALLET_LOAD_AMOUNT) return "Montant invalide:\nminimum = $MINIMUM_WALLET_LOAD_AMOUNT FCFA";
                      if(model.chosenPaymentMethod == null) return "Choisir moyen de paiement";
                      return null;
                    },
                  ),
                  ListTile(
                    horizontalTitleGap: 0,
                    title: const Text('Flooz', style: TextStyle(fontSize: 12.0)),
                    leading: Radio<EPaymentMethod>(
                      activeColor: Theme.of(context).primaryColor,
                      value: EPaymentMethod.FLOOZ,
                      groupValue: model.chosenPaymentMethod,
                      onChanged: (EPaymentMethod value) => model.choosePaymentMethod(value),
                    ),
                  ),
                  ListTile(
                    horizontalTitleGap: 0,
                    title: const Text('TMoney', style: TextStyle(fontSize: 12.0)),
                    leading: Radio<EPaymentMethod>(
                      activeColor: Theme.of(context).primaryColor,
                      value: EPaymentMethod.TMONEY,
                      groupValue: model.chosenPaymentMethod,
                      onChanged: (EPaymentMethod value) => model.choosePaymentMethod(value),
                    ),
                  ),
                  model.chosenPaymentMethod != null ? TextFormField(
                    controller: model.phoneNumberCtrl,
                    decoration: customInputDecoration(
                        context,
                        label: 'Numéro ${EnumToString.convertToString(model.chosenPaymentMethod)}',
                        hint: 'Sans indicatif'
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if(value.isEmpty) return "Votre numéro ${EnumToString.convertToString(model.chosenPaymentMethod)} svp";
                      return null;
                    },
                  ) : Container(),
                  Button(model.loadBalance, 'Procéder')
                ],
              ),
            ),
          ),
        )
      )
    );
  }
}
