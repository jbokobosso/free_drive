import 'package:flutter/material.dart';

class TitleBanner extends StatelessWidget {
  String titleText;
  TitleBanner({@required this.titleText});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
          this.titleText,
          style: Theme.of(context).textTheme.headline1
      ),
    );
  }
}
