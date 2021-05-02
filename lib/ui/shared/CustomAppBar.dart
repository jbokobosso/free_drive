import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  String title;
  CustomAppBar(this.title);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(this.title),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
