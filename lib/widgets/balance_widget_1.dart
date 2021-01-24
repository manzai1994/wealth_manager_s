import 'package:flutter/material.dart';
import 'package:wealthmanager/data/constant_class.dart';
import 'package:wealthmanager/widgets/account_balance_widget.dart';
import 'package:wealthmanager/classes/account_item_class.dart';

class BalanceWidget1 extends StatelessWidget {
  final List<AccountItem> lAccounts;

  BalanceWidget1({this.lAccounts});
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
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              AccountBalanceWidget(
                leftRight: "Left",
                selAccount: lAccounts.first,
                listAccounts: lAccounts,
              ),
            ],
          ),
        )
      ],
    );
  }
}
