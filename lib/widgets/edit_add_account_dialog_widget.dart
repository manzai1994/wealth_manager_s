import 'package:flutter/material.dart';
import 'package:wealthmanager/classes/account_item_class.dart';
import 'package:wealthmanager/widgets/edit_add_account_widget.dart';

class EditAddAccountDialog extends StatelessWidget {
  AccountItem account;
  ValueChanged<AccountItem> onAdd;
  ValueChanged<AccountItem> onEdit;
  EditAddAccountDialog({this.account, this.onAdd, this.onEdit});

  @override
  Widget build(BuildContext context) {

//    if (account.name.contains("MBB")){
//      account.imagePath = "assets/images/card_logo/mbb.png";
//    }else if (account.name.contains("RHB")){
//      account.imagePath = "assets/images/card_logo/rhb.png";
//    }else if (account.name.contains("PBB")){
//      account.imagePath = "assets/images/card_logo/pbb.png";
//    }else if (account.name.contains("Cash")) {
//      account.imagePath = "assets/images/card_logo/rm.png";
//    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      content: SingleChildScrollView(
        child: EditAddAccount(
          account: account,
          onAdd: onAdd, onEdit: onEdit,
        ),
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}