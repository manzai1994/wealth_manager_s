import 'package:flutter/material.dart';
import 'package:wealthmanager/data/constant_class.dart';
import 'package:wealthmanager/classes/account_item_class.dart';


class BankSelectionDialog extends StatefulWidget {
  List<AccountItem> bankAccounts;
  AccountItem selBank;
  ValueChanged<AccountItem> onChangedBank;
  BankSelectionDialog({this.bankAccounts,this.selBank,this.onChangedBank});
  @override
  _BankSelectionDialogState createState() => _BankSelectionDialogState();
}
class _BankSelectionDialogState extends State<BankSelectionDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: widget.bankAccounts.map((account) {
            return RadioListTile(
                title: Text("${account.name}(${account.id})"),
                activeColor: selBankColor,
                toggleable: true,
                value: "${account.name} - ${account.id}",
                groupValue: "${widget.selBank.name} - ${widget.selBank.id}",
                onChanged: (val){
                  setState(() {
                    widget.selBank = account;
                    widget.bankAccounts.forEach((account) {
                      if("${account.name}(${account.id})" == "${widget.selBank.name}(${widget.selBank.id})"){
                        widget.onChangedBank(account);
                        Navigator.pop(context);
                      }
                    });
                  });
                });
          }).toList(),
        ),
      ),
      actions: [
        MaterialButton(
          child: Text("Cancel"),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}