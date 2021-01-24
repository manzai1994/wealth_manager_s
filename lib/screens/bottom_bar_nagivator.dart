
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wealthmanager/screens/edit_add_account.dart';
import 'package:wealthmanager/screens/home.dart';
import 'package:wealthmanager/classes/bottom_bar_navi_item.dart';
import 'package:wealthmanager/screens/history.dart';

class BottomBarNavigator extends StatefulWidget {
  @override
  _BottomBarNavigatorState createState() => _BottomBarNavigatorState();
}

class _BottomBarNavigatorState extends State<BottomBarNavigator> {
  double currentIndexPage = 0;
  int currentIndex = 0;

  List<BtmNaviItem> btmNaviItems = List<BtmNaviItem>.from([
    BtmNaviItem(page: Home(),icon: Icon(Icons.account_balance),pageName: "Home"),
    BtmNaviItem(page: EditAddBankAcc(setup: false,),icon: Icon(Icons.account_balance_wallet),pageName: "Accounts"),
    BtmNaviItem(page: History(),icon: Icon(Icons.history),pageName: "History"),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: btmNaviItems[currentIndex].page,

      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          print("item index: $index");
          currentIndex = index;
          setState(() {});
        },
        currentIndex: currentIndex,
        items: btmNaviItems.map((btmNaviItem) {
          return BottomNavigationBarItem(
            icon: btmNaviItems[btmNaviItems.indexOf(btmNaviItem)].icon,
            label: btmNaviItems[btmNaviItems.indexOf(btmNaviItem)].pageName
          );
        }).toList(),
      ),
    );
  }
}