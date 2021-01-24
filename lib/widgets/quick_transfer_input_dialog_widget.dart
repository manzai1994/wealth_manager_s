import 'package:flutter/material.dart';
import 'package:wealthmanager/data/constant_class.dart';
import 'package:wealthmanager/widgets/cancel_button_widget.dart';
import 'package:wealthmanager/widgets/confirm_button_widget.dart';

class QuickTransferInputDialog extends StatelessWidget {
  String title;
  String direction;
  TextEditingController mCBAmount = TextEditingController();
  final ValueChanged<dynamic> onChanged;

  QuickTransferInputDialog({this.title, this.direction, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      title: Text(
        title, textAlign: TextAlign.center,
        style: TextStyle(fontSize: head2size, color: txtColor),
      ),
      content: TextField(
        keyboardType: TextInputType.number,
        controller: mCBAmount,
        decoration: InputDecoration(
          labelText: "Amount to Transfer",
          labelStyle: TextStyle(
            color: txtColor,
            fontSize: head3size,
          ),
        ),
      ),
      actions: <Widget>[
        ConfirmButton(
          onPressed: (){
            onChanged(mCBAmount.text);
            Navigator.pop(context);
          },
        ),
        CancelButton(
          onPressed: (){
            mCBAmount.clear();
            Navigator.pop(context);
          },
        ),
        /*MaterialButton(
          child: Text("CONFIRM",style: TextStyle(
            color: Colors.blue[700],),),
          elevation: 5.0,
          onPressed: (){
            onChanged(mCBAmount.text);
            Navigator.pop(context);
          },
        ),*/
        /*MaterialButton(
          child: Text("Cancel",style: TextStyle(
            color: txtColor,),),
          elevation: 5.0,
          onPressed: (){
            mCBAmount.clear();
            Navigator.pop(context);
          },
        )*/
      ],
    );

  }
}
