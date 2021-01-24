import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:wealthmanager/Services/database.dart';
import 'package:wealthmanager/classes/account_item_class.dart';
import 'package:wealthmanager/widgets/confirm_button_widget.dart';
import 'package:wealthmanager/widgets/cancel_button_widget.dart';
import 'package:wealthmanager/data/constant_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';


class NewShortcutDialog extends StatefulWidget {
  User user;
  String amount, precinout;
  List<AccountItem> listAccounts;
  AccountItem selAccount;

  NewShortcutDialog({this.user,this.amount,this.precinout,this.listAccounts,this.selAccount});

  @override
  _NewShortcutDialogState createState() => _NewShortcutDialogState();
}

class _NewShortcutDialogState extends State<NewShortcutDialog> {

  TextEditingController mType = TextEditingController();
  TextEditingController mAmount = TextEditingController();
  String precinout, premethod;

  @override
  void initState() {
    mAmount.text = widget.amount;
    precinout = widget.precinout;
    premethod = widget.selAccount.name+widget.selAccount.id;
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Center(child: Text("New Shortcut")),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.all(20),
      content: Wrap(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              //color: Colors.blue[100],
            ),
            child: Column(
              children: [
                TextField(
                  controller: mType,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      labelText: typKey,
                      labelStyle: TextStyle(
                        fontSize: head2size,
                      )
                  ),
                ),
                TextField(
                  controller: mAmount,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      labelText: amtKey,
                      labelStyle: TextStyle(
                        fontSize: head2size,

                      )
                  ),
                ),
                SizedBox(height: 10,),
                RadioListTile(
                  title: Text("Debit",style: TextStyle(fontSize: head2size, color: txtColor),),
                  value: debit,
                  activeColor: cioRdColor,
                  groupValue: precinout,
                  onChanged: (val){
                    precinout = val;
                    setState(() {});
                  },
                ),
                RadioListTile(
                  dense: true,
                  title: Text("Credit",style: TextStyle(fontSize: head2size, color: txtColor),),
                  value: credit,
                  activeColor: cioRdColor,
                  groupValue: precinout,
                  onChanged: (val){
                    precinout = val;
                    setState(() {});
                  },
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [BoxShadow(
                      color: Colors.blue[200],
                      offset: Offset(-5, 3),
                      blurRadius: 10.0,
                    )],
                  ),
                  child: DropdownButton(
                    dropdownColor: Colors.white,
                    isExpanded: true,
                    value: premethod,
                    items: widget.listAccounts.map((account){
                      return DropdownMenuItem(
                        child: Center(child: Text("${account.name}(${account.id})",)),
                        value: account.name+account.id,
                      );
                    }).toList(),
                    onChanged: (method){
                      premethod = method;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          /*Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Text("Confirm", style: TextStyle(color: Colors.grey[850]),),
                          color: Colors.purple[200],
                          onPressed: (){
                            Map<String, dynamic> txShortcut = Map<String, dynamic>();
                            txShortcut.addAll({TextEditingController().text: [
                              double.parse(mAmount.text).toStringAsFixed(2),
                              precinout,
                              premethod,
                            ]});
                            DatabaseService(uid: user.uid).updateTXShortcut(txShortcut);
                          },
                        )
                      ],
                    ),*/
        ],
      ),
      actions: [
        ConfirmButton(
          onPressed: () async{
            Map<String, dynamic> shortcuts = Map<String,dynamic>();
            shortcuts = {mType.text : [
              double.parse(mAmount.text).toStringAsFixed(2),
              precinout,
              premethod,
            ]};
            await DatabaseService(uid: widget.user.uid).updateTXShortcut(shortcuts);
            Navigator.pop(context);
          },
        ),
        CancelButton(
          onPressed: (){
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
