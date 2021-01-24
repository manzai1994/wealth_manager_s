import 'package:flutter/material.dart';

class FloatingUpdateButton extends StatelessWidget {
  VoidCallback onPress;

  FloatingUpdateButton({this.onPress});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(Icons.update),
      label: Text("Update"),
      onPressed: onPress,
    );
  }
}
