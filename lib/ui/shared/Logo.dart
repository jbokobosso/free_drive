import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  double sizeScale;
  Logo({this.sizeScale = 0.2});

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(20),
      width: deviceWidth*this.sizeScale,
      height: deviceWidth*this.sizeScale,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage("assets/icons/logo.png"),
              fit: BoxFit.contain
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 10.0,
                spreadRadius: 5.0
            )
          ]
        // border: Border.all(color: Theme.of(context).primaryColor)
      ),
    );
  }
}