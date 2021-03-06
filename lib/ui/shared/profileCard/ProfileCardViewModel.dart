import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/services/AuthService.dart';
import 'package:free_drive/services/ContactDriverService.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/ProfileService.dart';
import 'package:free_drive/services/ServiceLocator.dart';
import 'package:free_drive/utils/Utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

enum EDestinationController {
  displayNameCtrl,
  phoneNumberCtrl
}

class ProfileCardViewModel extends BaseViewModel {

  CoreService coreService = getIt.get<CoreService>();
  AuthService authService = getIt.get<AuthService>();
  ProfileService _profileService = getIt.get<ProfileService>();
  ContactDriverService contactDriverService = getIt.get<ContactDriverService>();
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isUploading = false;
  bool isUpdating = false;
  double uploadPercentage = 0;

  UserModel get loggedUser => coreService.loggedUser;
  String profilePictureUrl;
  bool get profilePictureLoaded => this.profilePictureUrl != null ;

  double get deviceWidth => this.coreService.deviceWidth;
  double get deviceHeight => this.coreService.deviceHeight;

  final updateFormKey = GlobalKey<FormState>();
  TextEditingController displayNameCtrl = new TextEditingController();
  TextEditingController phoneNumberCtrl = new TextEditingController();

  final picker = ImagePicker();

  initView() {
    setBusy(true);
    this.loadLocallyLoggedUser();
    this.loadAndSetProfilePictureUrl();
    this.displayNameCtrl.text = this.loggedUser.displayName;
    this.phoneNumberCtrl.text = this.loggedUser.phoneNumber;
    setBusy(false);
  }

  loadLocallyLoggedUser() async {
    var result  = await this.authService.getLoggedUser();
    this.coreService.loggedUser = result;
    notifyListeners();
  }

  Future<dynamic> buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Cam??ra ou Gallerie ?"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () => this.pickProfilePicture(true), icon: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor)),
              IconButton(onPressed: () => this.pickProfilePicture(false), icon: Icon(Icons.photo, color: Theme.of(context).primaryColor)),
            ],
          ),
        )
    );
  }

  pickProfilePicture(bool isCamera) async {
    navigatorKey.currentState.pop(); // close the modal for choosing picture from gallery or camera
    PickedFile pickedFile = await picker.getImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
    if(pickedFile != null) {
      File file = File(pickedFile.path);
      if(this.coreService.fileIsImage(file))
        uploadProfilePicture(File(file.path), this.loggedUser.userType);
      else
        this.coreService.showErrorDialog("Erreur Fichier", "Format de fichier non support??. Veuillez s??lectionner une image photo prise par une cam??ra.");
    } else {
      this.coreService.showToastMessage("Aucune image choisie");
    }
  }

  Future<bool> uploadProfilePicture(File file, EUserType userType) async {
    this.isUploading = true;
    this.uploadPercentage = 0;
    notifyListeners();
    String destinationFolder = userType == EUserType.driver ? FS_driverProfileLocation : FS_clientProfileLocation;
    try {
      Stream<TaskSnapshot> taskStream = this.firebaseStorage.ref("$destinationFolder/" + this.firebaseAuth.currentUser.uid).putFile(file).snapshotEvents;
      await for (TaskSnapshot taskSnapshot in taskStream) {
        this.uploadPercentage = (taskSnapshot.bytesTransferred*100)/taskSnapshot.totalBytes;
        notifyListeners();
        if(this.isUploading)
          this.profilePictureUrl = await taskSnapshot.ref.getDownloadURL();
        if(uploadPercentage == 100)
          break;
      }
      this.isUploading = false;
      notifyListeners();
      this.coreService.showToastMessage("Image t??l??vers??e en ligne !");
      bool storedImage = await this.storeProfilePictureUrl(this.profilePictureUrl);
      if(storedImage)
        this.coreService.showToastMessage("Image sauvegard??e en local");
      else
        this.coreService.showErrorDialog("", "L'image a ??t?? t??l??vers??e mais n'a pas pu ??tre sauvegard??e sur votre t??l??phone.\nVeuillez rafraichir");
      notifyListeners();
    } catch (e) {
      this.isUploading = false;
      notifyListeners();
      this.coreService.showErrorDialog("Erreur T??l??versement", e.toString());
    }
    this.isUploading = false;
    notifyListeners();
    return true;
  }

  Future<bool> storeProfilePictureUrl(String url) async {
    return await this.coreService.storeProfilePictureUrl(url);
  }

  void loadAndSetProfilePictureUrl() async {
    this.profilePictureUrl = await this.coreService.getProfilePictureUrl();
  }

  setIsUpdating(bool value) {
    this.isUpdating = value;
    this.notifyListeners();
  }

  updateName() async {
    bool isValid = this.updateFormKey.currentState.validate();
    if(!isValid) return;
    setIsUpdating(true);
    navigatorKey.currentState.pop();
    bool success = await this._profileService.updateDisplayName(this.displayNameCtrl.text);
    success ? Utils.showToast("Nom mis ?? jour") : Utils.showToast("Erreur, veuillez re??ssayer");
    this.loadLocallyLoggedUser();
    setIsUpdating(false);
  }

  updatePhonenumber() async {
    bool isValid = this.updateFormKey.currentState.validate();
    if(!isValid) return;
    setIsUpdating(true);
    navigatorKey.currentState.pop();
    bool success = await this._profileService.updatePhoneNumber(this.phoneNumberCtrl.text);
    success ? Utils.showToast("T??l??hone mis ?? jour") : Utils.showToast("Erreur, veuillez re??ssayer");
    this.loadLocallyLoggedUser();
    setIsUpdating(false);
  }

  updateFormValidator(String value, EDestinationController destinationController) {
    switch(destinationController) {
      case EDestinationController.displayNameCtrl:
        if(value.isEmpty) return "Saisir nouveau nom";
      break;
      case EDestinationController.phoneNumberCtrl:
        if(value.isEmpty) return "Saisir nouveau num??ro";
      break;
      default:
        return null;
      break;
    }
  }

  showUpdateDialog({EDestinationController destinationController}) {
    return showDialog(
        context: navigatorKey.currentContext,
        builder: (_) => SizedBox(
          height: Utils.deviceHeight*0.5,
          child: AlertDialog(
              title: Text("Changer ${destinationController == EDestinationController.displayNameCtrl ? 'nom' : 'num??ro'}"),
              content: Form(
                key: this.updateFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextFormField(
                    validator: (String value) => this.updateFormValidator(value, destinationController),
                    controller: destinationController == EDestinationController.displayNameCtrl ? this.displayNameCtrl : this.phoneNumberCtrl,
                    decoration: InputDecoration(
                        label: Text(destinationController == EDestinationController.displayNameCtrl ? 'Entrez votre nom' : 'Num??ro de t??l??phone')
                    ),
                    keyboardType: destinationController == EDestinationController.displayNameCtrl ? TextInputType.text : TextInputType.phone,
                    autofocus: true
                  ),
                ),
              ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  primary: Colors.white
                ),
                child: Text('Annuler'),
                onPressed: () => navigatorKey.currentState.pop(),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(navigatorKey.currentContext).primaryColor,
                  primary: Colors.white
                ),
                child: Text('Changer'),
                onPressed: () => destinationController == EDestinationController.displayNameCtrl ? this.updateName() : this.updatePhonenumber(),
              )
            ],
          ),
        )
    );
  }

}