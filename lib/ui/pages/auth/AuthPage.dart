import 'package:flutter/material.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:stacked/stacked.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar('Auth Page'),
      ),
      viewModelBuilder: () => AppViewModel(),
    );
  }
}
