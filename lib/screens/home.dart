
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wealthmanager/Services/auth.dart';
import 'package:wealthmanager/Services/database.dart';
import 'package:intl/intl.dart';

import 'package:wealthmanager/screens/drawer_menu.dart';

import 'package:wealthmanager/widgets/balance_widget.dart';
import 'package:wealthmanager/widgets/cancel_button_widget.dart';
import 'package:wealthmanager/widgets/confirm_button_widget.dart';
import 'package:wealthmanager/widgets/new_shortcut_dialog.dart';
import 'package:wealthmanager/widgets/transaction_widget.dart';
import 'package:wealthmanager/widgets/quick_transfer_input_dialog_widget.dart';

import 'package:wealthmanager/classes/account_item_class.dart';
import 'package:wealthmanager/screens/loading.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:wealthmanager/data/global_variables.dart';
import 'package:wealthmanager/data/constant_class.dart';
import 'package:wealthmanager/classes/shortcut_item_class.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController mAmount = TextEditingController();
  TextEditingController mNote = TextEditingController();
  String precinout, premethod;
  ShortcutItem TX;
  Map<String,dynamic> tcdJson, asdJson, thdJson, amyJson;
  AccountItem leftAccount, rightAccount;
  AccountItem selAccount;
  List<AccountItem> listAccounts = List<AccountItem>();
  List<ShortcutItem> listShortcuts = List<ShortcutItem>();
  User user;
  bool skip = false;
  int lastIDNum = 0;


  void _onBalanceWidgetChanged(Map<String, dynamic> actionMap){
    String action1 = actionMap.keys.first;
    AccountItem accItem = actionMap[action1];
    if (action1.contains("Update")){
      if (action1.contains("Left")){
        leftAccount = accItem;
      }else if (action1.contains("Right")){
        rightAccount = accItem;
      }
      setState(() {});
    }
    else if (action1.contains("Transfer")){
      skip = false;
      String action2 = actionMap.keys.last;
      AccountItem txFrom = actionMap[action1];
      AccountItem txTo = actionMap[action2];

      String title = "From ${txFrom.name} To ${txTo.name}";

      showDialog(
          context: context,
          builder: (_){
            return QuickTransferInputDialog(
              title: title,
              onChanged: (txValue) async{
                await updateAccBalanceData(txFrom: txFrom, txTo: txTo, txValue: txValue);
                setState(() {});
              },
            );
          }
      );
    }
  }
  /*void updateAccountsVariables(){
    if (listAccounts == null){
      //initialize list of accounts
      listAccounts = List<AccountItem>();
      listAccounts.clear();
      mapAccBalance.forEach((key, value) {
        List<String> nameID = key.split("-");
        listAccounts.add(AccountItem(dummy: false, name:nameID[0], id: nameID[1],amount: value));
      });

      //if Accounts >= 2, use format2, assign left and right account to be shown.
      if (listAccounts.length >= 2 && leftAccount == null && rightAccount == null){
        leftAccount = listAccounts[0];
        rightAccount = listAccounts[1];
      }
      //if selAccount == null, set the first account as the transaction option
      if (selAccount == null){
        selAccount = listAccounts.first;
      }

      if (mapTXShortcut!=null){
        mapTXShortcut.forEach((key, value) {
          List<String> lvalue = value;
          print("mapTXShortcut: ${lvalue}");
        });
      }
    }
  }*/

  Future<bool> updateAccBalanceData({AccountItem txFrom, AccountItem txTo, String txValue}) async{

    //ignore txFrom when doing normal transaction
    try {
      String fromFinal, toFinal;
      //List<AccountItem> listAccounts_temp = List<AccountItem>.of(listAccounts);

      if (txFrom != null){
        fromFinal = (double.parse(txFrom.amount) - double.parse(txValue)).toStringAsFixed(2);
        await DatabaseService(uid: user.uid).updateAccount(
            AccountItem(
              dummy: false,
              name: txFrom.name,
              id: txFrom.id,
              amount: fromFinal,
            )
        );
      }
      toFinal = (double.parse(txTo.amount) + double.parse(txValue)).toStringAsFixed(2);
      await DatabaseService(uid: user.uid).updateAccount(
          AccountItem(
            dummy: false,
            name: txTo.name,
            id: txTo.id,
            amount: toFinal,
          )
      );

      //convert log cash & bank to String and save Date-Time&Description to file
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('dd\-MMM yy\nhh:mm a');
      final String formatted = formatter.format(now);
      String month = formatted.substring(3,6);
      String year = formatted.substring(7,9);

      String descrp;
      if (mNote.text.trim() == ""){
        descrp = TX.type;
      }else{
        descrp = TX.type+" - "+mNote.text;
      }


      if (txFrom == null){
        Map<String, dynamic> txlog = {
          "id": "$month $year-${lastIDNum++}",
          "date": formatted,
          "descr": descrp,
          "to": "${txTo.name}-${txTo.id}",
          "from": "na",
          "amount": txValue,
        };
        await DatabaseService(uid: user.uid).createUpdateHist(txlog);
      }else{
        Map<String, dynamic> txlog = {
          "id": "$month $year-${lastIDNum++}",
          "date": formatted,
          "descr": "${txFrom.name}(${txFrom.id}) -> ${txTo.name}(${txTo.id})",
          "to": "${txTo.name}-${txTo.id}",
          "from": "${txFrom.name}-${txFrom.id}",
          "amount": txValue,
        };
        await DatabaseService(uid: user.uid).createUpdateHist(txlog);
      }
      return true;
    }catch(e){
      print("error: $e");
      return false;
    }

    /*listAccounts_temp.forEach((account) {
      if (account.name+account.id == txFrom.name+txFrom.id){
        account.amount = fromFinal;
      } else if (account.name+account.id == txTo.name+txTo.id){
        account.amount = toFinal;
      }
    });
*/


  }

  Future<bool> readDatabaseData() async{
    if (!skip){
      Map<String, dynamic> mapAccBalance = await DatabaseService(uid: user.uid).readUserData("AccountsBalance");
      print("mapAccBalance: ${mapAccBalance}");
      //extract map of accounts
      if (mapAccBalance!=null){
        listAccounts.clear();
        mapAccBalance.forEach((key, value) {
            List<String> nameID = key.split("-");
            listAccounts.add(AccountItem(dummy: false, name:nameID[0], id: nameID[1],amount: value));
        });
      }
      //extract array accounts
      /*if (mapAccBalance!=null){
        listAccounts.clear();
        mapAccBalance.forEach((key, value) {
          List<dynamic> temp = List<dynamic>.from(value);
          temp.forEach((accBalance) {
            Map<String, dynamic> accBal = accBalance;
            String key = accBal.keys.first;
            String val = accBal.values.first;
            List<String> nameID = key.split("-");
            listAccounts.add(AccountItem(dummy: false, name:nameID[0], id: nameID[1],amount: val));
          });
        });
      }*/

      Map<String, dynamic> mapTXShortcut = await DatabaseService(uid: user.uid).readUserData("TXShortcuts");
      if (mapTXShortcut!=null){
        listShortcuts.clear();
        mapTXShortcut.forEach((key, value) {
          listShortcuts.add(ShortcutItem(type: key, settings: value));
        });
      }

      Map<String, dynamic> mapHistory = await DatabaseService(uid: user.uid).readUserData("History");

      lastIDNum = int.parse(mapHistory["lastID"])+1;

      skip = true;
      if (mapAccBalance!=null && mapTXShortcut!=null)
        return true;
      else
        return false;
    } else{
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    print("home build");

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cash Flow"),
        actions: [
          Container(
            color: Colors.transparent,
            alignment: Alignment.centerRight,
            child: FlatButton.icon(
              color: Colors.transparent,
              icon: Icon(Icons.add_circle),
              label: Text("Add\nShortcut", textAlign: TextAlign.center,),
              onPressed: (){
                showDialog(
                  useSafeArea: false,
                  context: context,
                  builder: (context){
                    return NewShortcutDialog(
                      user: user,
                      amount: mAmount.text,
                      precinout: precinout,
                      listAccounts: listAccounts,
                      selAccount: selAccount,
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
      /*drawer: DrawerMenu(),*/
      body: Builder(
        builder: (context) => GestureDetector(
          onTap: (){FocusScope.of(context).requestFocus(new FocusNode());},
          child: FutureBuilder(
            future: readDatabaseData(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              print("home readDatabaseData skip: ${skip}");
              if (/*(snapshot.connectionState != ConnectionState.done )*/ !skip) {
                return Loading();
              } else if (snapshot.hasData){
                //updateAccountsVariables();
                //if Accounts >= 2, use format2, assign left and right account to be shown.
                if (listAccounts.length >= 2 && leftAccount == null && rightAccount == null){
                  leftAccount = listAccounts[0];
                  rightAccount = listAccounts[1];
                } else if (listAccounts.length >= 2){
                  listAccounts.forEach((account) {
                    if (leftAccount.name+leftAccount.id == account.name+account.id){
                      leftAccount = account;
                    }else if (rightAccount.name+rightAccount.id == account.name+account.id){
                      rightAccount = account;
                    }
                  });
                }

                //if selAccount == null, set the first account as the transaction option
                if (selAccount == null){
                  selAccount = listAccounts.first;
                } else{
                  listAccounts.forEach((account) {
                    if (selAccount.name+selAccount.id == account.name+account.id){
                      selAccount = account;
                    }
                  });
                }

                if (TX == null){
                  TX = listShortcuts.first;
                }else{
                  listShortcuts.forEach((shortcut) {
                    if (TX.type == shortcut.type){
                      TX = shortcut;
                    }
                  });
                }

                return SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20,10,20,10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            BalanceWidget(
                              leftAccount: leftAccount,
                              rightAccount: rightAccount,
                              listAccounts: listAccounts,
                              onChanged: (action){

                                _onBalanceWidgetChanged(action);
                              },
                            ),
                            SizedBox(height: 10,),
                            TransactionWidget(
                              mAmount: mAmount,
                              mNote: mNote,
                              shortcuts: listShortcuts,
                              TX: TX,
                              allAccounts: listAccounts,
                              selAccount: selAccount,
                              precinout: precinout,
                              onChanged: (msg){
                                Map<String, dynamic> message = msg;
                                String item = message.keys.first;
                                print("message: $message");
                                if (item == "selAccount"){
                                  selAccount = message.values.first;
                                } else if (item == "precinout"){
                                  precinout = message.values.first;
                                } else if (item == "type"){
                                  TX = message.values.first;
                                  print("TW type return: ${TX.type}, ${TX.settings}");
                                  mAmount.text = TX.settings[0];
                                  precinout = TX.settings[1];
                                  listAccounts.forEach((account) {
                                    if (account.name+account.id == TX.settings[2]){
                                      selAccount = account;
                                    }
                                  });
                                }
                                setState(() {});
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                RaisedButton(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: Text("Confirm", style: TextStyle(color: Colors.grey[850]),),
                                  color: Colors.purple[200],
                                  onPressed: () async{
                                    String txValue = precinout==debit? mAmount.text: "-"+mAmount.text;
                                    await updateAccBalanceData(txTo: selAccount, txValue: txValue);
                                    skip = false;
                                    setState(() {});
                                    /*final snackBar = SnackBar(
                                      content: Text(TX + " - " + premethod + " - " + precinout + " - " + mAmount.text),
                                      duration: Duration(seconds: 2),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () {
                                          List<double> removeValues = List<double>();
                                          lid.removeLast();
                                          ldate.removeLast();
                                          ldescr.removeLast();
                                          //undo for banks
                                          for (int i = 0; i < laccsname.length; i++){
                                            removeValues.add(double.parse(laccsamt[i].last));
                                            laccsamt[i].removeLast();
                                          }

                                          thdJson["ID"] = lid;
                                          thdJson[date] = ldate;
                                          thdJson[descr] = ldescr;
                                          for (int i = 0; i < laccsname.length; i++){
                                            thdJson[laccsname[i]] = laccsamt[i];
                                          }
                                          txHistFileName.writeAsStringSync(jsonEncode(thdJson));

                                          for (int i = 0; i < asdJson.length; i++){
                                            String account = asdJson.keys.elementAt(i);
                                            String amount = asdJson[asdJson.keys.elementAt(i)];
                                            amount = (double.parse(amount) - removeValues[i]).toStringAsFixed(2);
                                            asdJson[account] = amount;
                                          }
                                          accSummFileName.writeAsStringSync(jsonEncode(asdJson));

                                          setState(() {});
                                        },
                                      ),
                                    );*/
                                    // Find the Scaffold in the widget tree and use
                                    // it to show a SnackBar.
                                    //ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  },
                                )
                              ],
                            )
                          ]
                      )
                  ),
                );
              }else{
                return Loading();
              }
            },
          ),
        ),
      ),
      /*floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Add Shortcut"),
        onPressed: (){

          showDialog(
            useSafeArea: false,
            context: context,
            builder: (context){
              return NewShortcutDialog(
                user: user,
                amount: mAmount.text,
                precinout: precinout,
                listAccounts: listAccounts,
                selAccount: selAccount,
              );
            },
          );
        },
      ),*/
      /*floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add_circle),
        label: Text("Try link to firebase"),
        onPressed: () {
          //_auth.signOut();

          setState(() {

          });
        },
      ),*/
    );
  }
  /*void updateAccSummFile(
      String txValue,
      String txNote,
      AccountItem txFrom,
      AccountItem txTo,
      bool quickTransfer,
      ){
    double dFromFinal, dToFinal;
    double dtxFromValue, dtxToValue;

    setState(() {
      //Calculate Final "To" and "From" amounts
      if (quickTransfer == false){
        dToFinal = double.parse(txTo.amount);
        dtxToValue = double.parse(txValue);
        if (precinout == credit){
          dtxToValue = -1*dtxToValue;
        }
        dToFinal += dtxToValue;
        txTo.amount = dToFinal.toStringAsFixed(2);
      }else{
        dFromFinal = double.parse(txFrom.amount);
        dToFinal = double.parse(txTo.amount);

        dtxFromValue = -double.parse(txValue);
        dtxToValue = double.parse(txValue);

        dFromFinal += dtxFromValue;
        dToFinal += dtxToValue;

        txFrom.amount = dFromFinal.toStringAsFixed(2);
        txTo.amount = dToFinal.toStringAsFixed(2);
      }

      //UPDATE account summary then save to file
      asdJson.forEach((account, amount) {
        if (account == (txTo.name + " - " +txTo.id)){
          asdJson[account] = txTo.amount;
        }
        if (quickTransfer){
          if (account == (txFrom.name + " - " +txFrom.id)){
            asdJson[account] = txFrom.amount;
          }
        }
      });
      accSummFileName.writeAsStringSync(jsonEncode(asdJson));

      //convert log cash & bank to String and save Date-Time&Description to file
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('dd\-MMM yy\nhh:mm a');
      final String formatted = formatter.format(now);
      String month = formatted.substring(3,6);
      String year = formatted.substring(7,9);
      int lastIDNum;
      //add ID
      if (lid.isEmpty)
        lastIDNum = 0;
      else
        lastIDNum = int.parse(lid.last.toString().substring(9));
      lid.add("$month $year - ${++lastIDNum}");
      //add date
      ldate.add(formatted);
      //add description
      if (txNote.trim() == "")
        ldescr.add(TX);
      else
        ldescr.add(TX+" - "+txNote);
      //add accounts transaction amounts
      for (int i = 0; i < laccsname.length; i++){
        String account = laccsname[i];
        bool NA = true;
        if (account == (txTo.name + " - " +txTo.id)){
          laccsamt[i].add(dtxToValue.toStringAsFixed(2));
          NA = false;
        }
        if (quickTransfer) {
          if (account == (txFrom.name + " - " + txFrom.id)) {
            laccsamt[i].add(dtxFromValue.toStringAsFixed(2));
            NA = false;
          }
        }
        if (NA){
          laccsamt[i].add("0.00");
        }
      }
      thdJson["ID"] = lid;
      thdJson[date] = ldate;
      thdJson[descr] = ldescr;
      for (int i = 3; i < thdJson.length; i++){
        thdJson[thdJson.keys.elementAt(i)] = laccsamt[i-3];
      }
      txHistFileName.writeAsStringSync(jsonEncode(thdJson));

      //update filter list
      if (!lmy.contains("$month $year")){
        lmy.add("$month $year");
        amyJson[my] = lmy;
        actMYFileName.writeAsStringSync(jsonEncode(amyJson));
      }
    });
  }*/
}