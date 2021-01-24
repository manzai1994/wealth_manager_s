import 'package:flutter/material.dart';
import 'package:wealthmanager/classes/account_item_class.dart';
import 'package:wealthmanager/data/constant_class.dart';

class AccountBalanceWidget extends StatelessWidget {
  String leftRight;
  AccountItem selAccount ,oppoAccount;
  List<AccountItem> listAccounts;
  final ValueChanged<Map<String,AccountItem>> onChanged;

  AccountBalanceWidget({
    this.leftRight,
    this.selAccount,
    this.oppoAccount,
    this.listAccounts,
    this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      builder: (BuildContext context, List<String> ls, List<dynamic> ld){
        return Column(
          children: <Widget>[
            DropdownButton(
              value: selAccount,
              items: listAccounts.map((accItem) {
                return DropdownMenuItem(
                  value: accItem,
                  child: Text(accItem.name+"("+accItem.id+")"),
                );
              }).toList(),
              onChanged: (selAcc){
                Map<String, AccountItem> returnValue = {"Update $leftRight": selAcc}; // Update Left Cash-RM
                onChanged(returnValue);
              },
            ),
            Text(selAccount.amount,style: TextStyle(fontSize: head2size,color: txtColor)),
          ],
        );
      },
      onAccept: (s){
        Map<String, AccountItem> quickTransfer = Map<String, AccountItem>();
        quickTransfer["Transfer"] = oppoAccount;
        quickTransfer["To"] = selAccount;
        onChanged(quickTransfer);
      },
    );
  }
}