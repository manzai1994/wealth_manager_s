import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {

  VoidCallback onPressed;
  ConfirmButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text("CONFIRM",style: TextStyle(
        color: Colors.blue[700],
        fontStyle: FontStyle.italic,
      ),),
      elevation: 5.0,
      onPressed: onPressed,
    );
  }
}
