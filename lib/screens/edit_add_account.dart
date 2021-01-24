import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:wealthmanager/Services/auth.dart';
import 'package:wealthmanager/Services/database.dart';
import '../data/constant_class.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:wealthmanager/widgets/floating_update_button.dart';
import 'package:wealthmanager/widgets/account_delete_dialog.dart';
import 'package:wealthmanager/widgets/account_update_warning_dialog.dart';
import 'package:wealthmanager/classes/account_item_class.dart';
import 'package:wealthmanager/widgets/account_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wealthmanager/data/global_variables.dart';
import 'package:wealthmanager/screens/loading.dart';

class EditAddBankAcc extends StatefulWidget {
  bool setup = false;
  Function backToWrapper;
  EditAddBankAcc({this.setup, this.backToWrapper});

  @override
  _EditAddBankAccState createState() => _EditAddBankAccState();
}

class _EditAddBankAccState extends State<EditAddBankAcc> {

  List<AccountItem> listAccounts = List<AccountItem>();
  bool editAdd = false, updateList = false;
  Widget floatingWidget;
  User user;
  bool skip = false;
  Map<String, dynamic> mapAccBalance = Map<String, dynamic>();

  Future<bool> readAccBalance({bool skip}) async{
    if (!skip){
      skip = true;
      mapAccBalance = await DatabaseService(uid: user.uid).readUserData("AccountsBalance");
      if (mapAccBalance!=null){
        listAccounts.clear();
        mapAccBalance.forEach((key, value) {
          List<String> nameID = key.split("-");
          listAccounts.add(AccountItem(dummy: false, name:nameID[0], id: nameID[1],amount: value));
        });
        return true;
      }
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
        return true;
      }*/
      return false;
    } else{
      return true;
    }
  }

  Future logHist() async{
    //convert log cash & bank to String and save Date-Time&Description to file
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd\-MMM yy\nhh:mm a');
    final String formatted = formatter.format(now);
    String month = formatted.substring(3,6);
    String year = formatted.substring(7,9);
    int lastIDNum = 1;

    //use for loop instead of foreach as foreach will cause async not working.
    for (int i = 0; i < listAccounts.length; i++) {
      AccountItem account = listAccounts.elementAt(i);
      if (account.amount != "0.00"){
        Map<String, dynamic> txlog = {
          "id": "$month $year-${lastIDNum++}",
          "date": formatted,
          "descr": "Adding ${account.name}-${account.id}",
          "to": "${account.name}-${account.id}",
          "from": "na",
          "amount": account.amount,
        };
        await DatabaseService(uid: user.uid).createUpdateHist(txlog);
      }
    }

    /*listAccounts.forEach((account) async{
      Map<String, dynamic> txlog = {
        "id": "$month $year-${lastIDNum++}",
        "descr": "Adding ${account.name}-${account.id}",
        "to": "${account.name}-${account.id}",
        "amount": account.amount,
      };
      bool test = await DatabaseService(uid: user.uid).createUpdateHist(txlog);
      print("test: $test");
    });*/
    return true;
  }
  @override
  Widget build(BuildContext context) {
    print("EditAddBankAcc build");
    user = Provider.of<User>(context);
    print("user: $user");
    if(widget.setup) {
      if (editAdd){
        floatingWidget = FloatingActionButton.extended(
          icon: Icon(Icons.chevron_right),
          label: Text("Confirm"),
          onPressed: () async{
            await DatabaseService(uid: user.uid).createAccountsAll(listAccounts);
            await DatabaseService(uid: user.uid).createTXShortcut({"Others": ["", credit, ""]});

            await logHist();

            editAdd = false;
            skip = false;
            widget.backToWrapper();
          },
        );
      }else{
        floatingWidget = null;
      }
    }else{
      if (editAdd) {
        floatingWidget = FloatingActionButton.extended(
          icon: Icon(Icons.update),
          label: Text("Update"),
          onPressed: ()async{
            await DatabaseService(uid: user.uid).updateAccountsAll(listAccounts);
            editAdd = false;
            skip = false;
            listAccounts.forEach((element) {
              mapAccBalance.forEach((key, value) {
                if ("${element.name}-${element.id}" == key){
                  element.amount = (double.parse(element.amount) - double.parse(value)).toStringAsFixed(2);
                }
              });

            });
            await logHist();
            setState(() {});
          },
        );
      }else{
        floatingWidget = null;
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("Edit/Add Bank Account"),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                listAccounts.add(AccountItem(dummy: true));
                skip = true;
                setState(() {

                });
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: readAccBalance(skip: skip),
        builder: (context, snapshot){
          print("edit_add_account readAccBalance snapshot: ${snapshot.data}");
          if (snapshot.hasData){
            return Scrollbar(
              thickness: 10,
              child: ListView(
                children: listAccounts.map((item) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: AccountCard(
                      accountItem: item,
                      onEdit: (acc){
                        editAdd = true;
                        skip = true;
                        setState(() {});
                      },
                      onAdd: (acc){
                        editAdd = true;
                        setState(() {});
                      },
                    ),
                    secondaryActions: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        child: IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () {
                            if (item.dummy){
                              editAdd = true;
                              listAccounts.removeLast();
                              setState(() {});
                            }else{
                              showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return DeleteAccountDialog(
                                    onDelete: () async{
                                      editAdd = false;
                                      print("item to delete: ${item.name} ${item.id}");
                                      listAccounts.remove(item);
                                      await DatabaseService(uid: user.uid).deleteAccount(item);
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          }else{
            return Loading();
          }


        },
      ),
      floatingActionButton: floatingWidget,
    );
  }
}
