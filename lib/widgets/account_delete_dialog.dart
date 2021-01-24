import 'package:flutter/material.dart';

class DeleteAccountDialog extends StatelessWidget {
  VoidCallback onDelete;
  DeleteAccountDialog({this.onDelete});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirm", textAlign: TextAlign.center,),
      content: ListTile(
        title: Text("Are you sure you wish to delete this Account?\n"),
        subtitle: Text("Reminder: Once delete, data will loss forever.\n\n"
            "Please hold 3 seconds to delete.",
          style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        ),
      ),
      actions: <Widget>[
        MaterialButton(//TODO: add hold 3 secs before deleting
            onPressed: onDelete,
            child: Text("DELETE", style: TextStyle(fontWeight: FontWeight.bold),)
        ),
        MaterialButton(
          onPressed: () => Navigator.pop(context),
          child: Text("CANCEL"),
        ),
      ],
    );
  }
}