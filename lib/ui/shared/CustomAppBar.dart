import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  String title;
  CustomAppBar({@required this.title});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(this.title),
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
      elevation: 0.0
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
