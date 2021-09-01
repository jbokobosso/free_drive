import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/GetIt.dart';

class ExceptionService {

  CoreService _coreService = getIt.get<CoreService>();

  manageExCeption(Exception exception) {
    this._coreService.showToastMessage("EXception not managed yet !");
  }

}