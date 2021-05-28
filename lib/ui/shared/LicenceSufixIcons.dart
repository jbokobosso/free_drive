import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:free_drive/state/AppViewModel.dart';

class LicenceSufixIcons extends StatelessWidget {
  const LicenceSufixIcons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
        builder: (context, model, child) => SizedBox(
          width: model.deviceWidth*0.25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SvgPicture.asset("assets/icons/file-upload.svg"),
              SizedBox(width: model.deviceWidth*0.05),
              SvgPicture.asset("assets/icons/camera.svg"),
              SizedBox(width: model.deviceWidth*0.1),
            ],
          ),
        ),
        viewModelBuilder: () => AppViewModel()
    );
  }
}
