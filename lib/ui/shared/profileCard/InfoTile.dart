import 'package:flutter/material.dart';
import 'package:free_drive/utils/Utils.dart';

class InfoTile extends StatelessWidget {
  Icon leadingIcon;
  bool isEditable;
  final Function onEditButtonTapped;
  String label;
  String content;
  String description;
  InfoTile(this.leadingIcon, this.label, this.content, {this.description, this.isEditable = false, this.onEditButtonTapped, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: this.leadingIcon,
      title: Text(this.label, style: TextStyle(color: Colors.grey, fontSize: Utils.deviceWidth*0.035)),
      subtitle: Text(this.content, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: Utils.deviceWidth*0.035)),
      trailing: this.isEditable ? IconButton(
        icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
        onPressed: this.onEditButtonTapped,
      ) : Text(''),
    );
  }
}
