import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {

  VoidCallback onPressed;
  CancelButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text("Cancel",style: TextStyle(
        fontStyle: FontStyle.italic,
      ),),
      elevation: 5.0,
      onPressed: onPressed,
    );
  }
}
