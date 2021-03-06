import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/ui/shared/Loading.dart';
import 'package:free_drive/ui/shared/profileCard/InfoTile.dart';
import 'package:free_drive/ui/shared/profileCard/ProfileCardViewModel.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

class ProfileCard extends StatelessWidget {
  final double cardTopSpacingScale = 0.2;
  final double cardWidth = 0.8;
  final TextStyle hightlightStyle = TextStyle(color: Theme.of(navigatorKey.currentContext).primaryColor, fontWeight: FontWeight.bold);
  ProfileCard();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileCardViewModel>.reactive(
      onModelReady: (model) => model.initView(),
      builder: (context, model, child) => model.isBusy ? Loading() : Positioned(
        top: model.deviceHeight*this.cardTopSpacingScale,
        child: Container(
          width: model.deviceWidth*this.cardWidth,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Theme.of(context).primaryColor,
                    spreadRadius: 0.1,
                    blurRadius: 0.5
                )
              ]
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: model.loggedUser != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                model.isUploading
                    ? Lottie.asset("assets/lottie/uploading.json", width: model.deviceWidth*0.5)
                    : GestureDetector(
                        onTap: () => model.buildShowDialog(context),
                        // child: Center(child: Icon(Icons.person, size: model.deviceWidth*0.5))
                        child: Center(
                          child: model.profilePictureLoaded
                              ? Stack(
                                  children: [
                                    CircleAvatar(
                                        radius: model.deviceWidth*0.15,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage(model.profilePictureUrl)
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: model.deviceWidth*0.01,
                                      child: CircleAvatar(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        child: Icon(Icons.camera_alt, color: Colors.white),
                                      )
                                    )
                                  ],
                                )
                              : Stack(
                                  children: [
                                    Icon(Icons.person, size: model.deviceWidth*0.25),
                                    Positioned(
                                      bottom: 0,
                                      right: model.deviceWidth*0.01,
                                      child: CircleAvatar(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        child: Icon(Icons.camera_alt, color: Colors.white),
                                      )
                                    )
                                  ],
                                )
                      )
                      ),
                model.isUploading
                    ? Center(
                        child: Text("\n${model.uploadPercentage.toInt().toString()} %",
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))
                      )
                    : Container(height: 0, width: 0),
                !model.isUpdating ? Column(
                  children: [
                    InfoTile(
                        Icon(Icons.person),
                        'Nom', model.loggedUser.displayName,
                        isEditable: true,
                        onEditButtonTapped: () => model.showUpdateDialog(destinationController: EDestinationController.displayNameCtrl)
                    ),
                    InfoTile(
                        Icon(Icons.phone),
                        'T??l??phone',
                        model.loggedUser.phoneNumber,
                        isEditable: true,
                        onEditButtonTapped: () => model.showUpdateDialog(destinationController: EDestinationController.phoneNumberCtrl)
                    )
                  ],
                ) : LoadingMini(),
                InfoTile(Icon(Icons.email), 'E-mail', model.loggedUser.email),
                model.coreService.loggedUser.userType == EUserType.driver // if user is driver, show account status. If not, show nothing (because client users are active by default)
                    ? Text('\nStatut: ${model.coreService.driverDashboardState.isActiveAccount != null ? "Activ??" : "Non actif"}')
                    : Text(""),
                model.isBusy ? Center(child: Loading()) : SizedBox(height: 0, width: 0)
              ],
            )
                : Center(child: CircularProgressIndicator())
          ),
        ),
      ),
      viewModelBuilder: () => ProfileCardViewModel(),
    );
  }
}
