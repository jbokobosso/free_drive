import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  String title;
  Function refreshCallback;
  CustomAppBar({@required this.title, this.refreshCallback});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(this.title),
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
      elevation: 0.0,
      actions: [
        this.refreshCallback != null ? IconButton(onPressed: this.refreshCallback, icon: Icon(Icons.refresh)) : Container()
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
