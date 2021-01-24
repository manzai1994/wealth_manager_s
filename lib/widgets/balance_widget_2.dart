import 'package:flutter/material.dart';
import 'package:wealthmanager/data/constant_class.dart';
import 'package:wealthmanager/widgets/account_balance_widget.dart';
import 'package:wealthmanager/classes/account_item_class.dart';

class BalanceWidget2 extends StatelessWidget {
  final AccountItem leftAccount, rightAccount;
  final List<AccountItem> lAccounts, rAccounts;
  final ValueChanged<Map<String,AccountItem>> onChanged;
  final double total;

  BalanceWidget2({this.leftAccount,this.rightAccount,this.lAccounts,this.rAccounts,this.total,this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
