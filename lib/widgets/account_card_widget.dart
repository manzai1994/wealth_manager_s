import 'package:flutter/material.dart';
import 'package:wealthmanager/classes/account_item_class.dart';
import 'package:wealthmanager/widgets/edit_add_account_dialog_widget.dart';

class AccountCard extends StatelessWidget {
  AccountItem accountItem;
  Color cardColor;
  ValueChanged<AccountItem> onAdd;
  ValueChanged<AccountItem> onEdit;
  AccountCard({this.accountItem, this.cardColor, this.onAdd, this.onEdit});

  @override
  Widget build(BuildContext context) {
    String imgPath;
    if (accountItem == null){
      accountItem = AccountItem(name: "- Tap To Create", id: "", amount: "--.--");
    }

    FontStyle fs1 = FontStyle.normal, fs2 = FontStyle.normal;
    Color clr1 = Colors.black, clr2 = Colors.grey[700];
    if (accountItem.name.contains("MBB")){
      imgPath = "assets/images/card_logo/mbb.png";
    }else if (accountItem.name.contains("RHB")){
      imgPath = "assets/images/card_logo/rhb.png";
    }else if (accountItem.name.contains("PBB")){
      imgPath = "assets/images/card_logo/pbb.png";
    }else if (accountItem.name.contains("Cash")){
      imgPath = "assets/images/card_logo/rm.png";
    }else if (accountItem.name.contains("CIMB")){
      imgPath = "assets/images/card_logo/cimb.png";
    }else{
      imgPath = "assets/images/card_logo/unknown.png";
      fs1 = FontStyle.italic;
      fs2 = FontStyle.italic;
      clr1 = Colors.grey;
      clr2 = Colors.grey;
    }
    accountItem.imagePath = imgPath;
    return Card(
      semanticContainer: false,
      margin: EdgeInsets.all(20),
      elevation: 13,
      child: ListTile(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context){
              return EditAddAccountDialog(account: accountItem, onAdd: onAdd, onEdit: onEdit,);
            },
          );
        },
        contentPadding: EdgeInsets.only(left: 30),
        leading: CircleAvatar(
          backgroundColor: Colors.indigoAccent,
          child: Image(
            alignment: Alignment.centerLeft,
            image: AssetImage(imgPath),
          ),
          foregroundColor: Colors.white,
        ),
        title: Padding(
            padding: EdgeInsets.only(left: 0),
            child: Text("${accountItem.name} - ${accountItem.id}", style: TextStyle(fontStyle: fs1, color: clr1, fontSize: 20),)),
        subtitle: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text("RM ${accountItem.amount}", style: TextStyle(fontStyle: fs2, color: clr2, fontSize: 18),)),
      ),
    );
  }
}