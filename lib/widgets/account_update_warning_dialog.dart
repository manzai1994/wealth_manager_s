import 'package:flutter/material.dart';

class UpdateWarningDialog extends StatelessWidget {
  VoidCallback onConfirm;
  UpdateWarningDialog({this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Take a stop"),
      content: Text("This action will be irreversible. Are you sure to continue?"),
      actions: [
        MaterialButton(
          child: Text("CONFIRM"),
          onPressed: (){
            onConfirm();
            Navigator.pop(context);
          },
        ),
        MaterialButton(
          child: Text("cancel"),
          onPressed: (){
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}