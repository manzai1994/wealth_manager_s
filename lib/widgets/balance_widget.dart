import 'package:flutter/material.dart';
import 'package:wealthmanager/data/constant_class.dart';
import 'package:wealthmanager/widgets/account_balance_widget.dart';
import 'package:wealthmanager/classes/account_item_class.dart';
import 'package:wealthmanager/widgets/balance_widget_2.dart';
import 'package:wealthmanager/widgets/balance_widget_1.dart';

class BalanceWidget extends StatelessWidget {
  final AccountItem leftAccount, rightAccount;
  final List<AccountItem> listAccounts;
  final ValueChanged<Map<String,AccountItem>> onChanged;

  BalanceWidget({this.leftAccount, this.rightAccount, this.listAccounts, this.onChanged});

  List<AccountItem> lAccounts, rAccounts;
  double total = 0.0;
  bool showFormat2;
  Widget balanceWidget;

  @override
  Widget build(BuildContext context) {
    showFormat2 = listAccounts.length >= 2;

    if (showFormat2){
      //extract only items needed for left account dropdown selection menu
      lAccounts = List<AccountItem>();
      lAccounts.addAll(listAccounts);
      List<AccountItem> tempLeftAccs = List<AccountItem>();
      tempLeftAccs.addAll(lAccounts);
      tempLeftAccs.forEach((account) {
        if (account.name+account.id == rightAccount.name+rightAccount.id){
          lAccounts.removeAt(tempLeftAccs.indexOf(account));
        }
      });

      //extract only items needed for right account dropdown selection menu
      rAccounts = List<AccountItem>();
      rAccounts.addAll(listAccounts);
      List<AccountItem> tempRightAccs = List<AccountItem>();
      tempRightAccs.addAll(rAccounts);
      tempRightAccs.forEach((account) {
        if (account.name+account.id == leftAccount.name+leftAccount.id)
          rAccounts.removeAt(tempRightAccs.indexOf(account));
      });

      //calculate total only if account numbers more than 2
      listAccounts.forEach((account) {
        total += double.parse(account.amount);
      });

      balanceWidget = BalanceWidget2(
        leftAccount: leftAccount,
        rightAccount: rightAccount,
        lAccounts: lAccounts,
        rAccounts: rAccounts,
        total: total,
        onChanged: onChanged,
      );
    }else{
      lAccounts = List<AccountItem>();
      lAccounts = [listAccounts.first];
      balanceWidget = BalanceWidget1(lAccounts: lAccounts);
    }


    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(4, 3), // changes position of shadow
          ),
        ],
      ),

      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: balanceWidget,

      /*Column(
        children: <Widget>[
          Text("Balance",
            style: TextStyle(
              fontSize: head1size,
              color: txtTtlColor,
            ),
          ),
          Text("Total: RM ${total.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: head2size,
              color: txtColor,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                AccountBalanceWidget(
                  leftRight: "Left",
                  selAccount: leftAccount,
                  oppoAccount: rightAccount,
                  listAccounts: lAccounts,
                  onChanged: onChanged,
                ),
                Draggable(
                  data: "quick transfer",
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: transIconBackColor,
                    ),
                    child: Icon(
                      Icons.repeat,
                      color: transIconColor,
                      size: 30,
                    ),
                  ),
                  feedback: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: transIconBackColor,
                    ),
                    child: Icon(
                      Icons.monetization_on,
                      color: transIconColor,
                      size: 30,
                    ),
                  ),
                  childWhenDragging: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: transIconBackColor,
                    ),
                    child: Icon(
                      Icons.repeat,
                      color: transIconColor,
                      size: 30,
                    ),
                  ),
                ),
                AccountBalanceWidget(
                  leftRight: "Right",
                  selAccount: rightAccount,
                  oppoAccount: leftAccount,
                  listAccounts: rAccounts,
                  onChanged: onChanged,
                ),
              ],
            ),
          )
        ],
      ),*/
    );
  }
}