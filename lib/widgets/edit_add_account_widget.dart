import 'package:flutter/material.dart';
import 'package:wealthmanager/data/constant_class.dart';
import 'package:wealthmanager/classes/account_item_class.dart';

class EditAddAccount extends StatefulWidget {
  AccountItem account;
  ValueChanged<AccountItem> onAdd;
  ValueChanged<AccountItem> onEdit;

  EditAddAccount({this.account, this.onAdd, this.onEdit});

  @override
  _EditAddAccountState createState() => _EditAddAccountState();
}

class _EditAddAccountState extends State<EditAddAccount> {
  String action;
  TextEditingController mName = TextEditingController();
  TextEditingController mID = TextEditingController();
  TextEditingController mAmount = TextEditingController();

  void _updateImage(){
    widget.account.name = mName.text;
//    if (widget.account.name.contains("MBB")){
//      widget.account.imagePath = "assets/images/card_logo/mbb.png";
//    }else if (widget.account.name.contains("RHB")){
//      widget.account.imagePath = "assets/images/card_logo/rhb.png";
//    }else if (widget.account.name.contains("PBB")){
//      widget.account.imagePath = "assets/images/card_logo/pbb.png";
//    }else if (widget.account.name.contains("Cash")) {
//      widget.account.imagePath = "assets/images/card_logo/rm.png";
//    }else{
//      widget.account.imagePath = "assets/images/card_logo/unknown.png";
//    }

    setState(() {print("updateImage: ${widget.account.imagePath}");});
  }

  void _editAccount(AccountItem account){
    widget.onEdit(AccountItem(dummy: false,name: account.name, id: account.id, amount: account.amount));
  }

  void _addAccount(AccountItem account){
    widget.onAdd((AccountItem(dummy: false, name: account.name, id: account.id, amount: account.amount)));
  }

  @override
  void initState() {
    super.initState();

    if (widget.account.id == ""){
      mName.text = "";
      mID.text = "";
      mAmount.text = "";
      action = "ADD";
      widget.account.imagePath = "assets/images/card_logo/unknown.png";
    }else{
      mName.text = widget.account.name;
      mID.text = widget.account.id;
      mAmount.text = widget.account.amount;
      action = "EDIT";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      onTap: _updateImage,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.name,
                      style: TextStyle(fontSize: 20),
                      controller: mName,
                      decoration: InputDecoration(hintText: "Account Name, eg: MBB",
                          hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 20)),
                    ),
                    TextField(
                      onTap: _updateImage,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.name,
                      controller: mID,
                      decoration: InputDecoration(hintText: "Last 4 digit of the Card, eg: 4564",
                          hintStyle: TextStyle(fontStyle: FontStyle.italic)),
                    ),
                    Row(
                      children: [
                        Flexible(flex: 1,child: Text("RM")),
                        SizedBox(width: 16.0),
                        Flexible(
                          flex: 2,
                          child: TextField(
                            onTap: _updateImage,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            controller: mAmount,
                            decoration: InputDecoration(hintText: "amount of this account",
                                hintStyle: TextStyle(fontStyle: FontStyle.italic)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // To close the dialog
                      },
                      child: Text("Cancel"),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: FlatButton(
                      onPressed: () {
                        widget.account.dummy = false;
                        widget.account.name = mName.text;
                        widget.account.id = mID.text;
                        widget.account.amount = (double.parse(mAmount.text)).toStringAsFixed(2);
                        if (action == "ADD"){
                          _addAccount(widget.account);
                        }else{
                          _editAccount(widget.account);
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(action),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: Consts.avatarRadius,
            child: Image(image: AssetImage(widget.account.imagePath), width: Consts.avatarRadius*2, fit: BoxFit.fitWidth,),

          ),
        ),
      ],
    );
  }
}