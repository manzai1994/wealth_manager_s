import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wealthmanager/Services/database.dart';
import 'package:wealthmanager/screens/loading.dart';
import '../data/constant_class.dart';
import '../classes/account_item_class.dart';
import 'package:wealthmanager/data/global_variables.dart';
import 'package:wealthmanager/data/constant_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class AddShortcut extends StatefulWidget {

  @override
  _AddShortcutState createState() => _AddShortcutState();
}

class _AddShortcutState extends State<AddShortcut> {

  final mType = TextEditingController(), mAmount = TextEditingController();
  String premethod, precinout;
  List<AccountItem> listAccounts = List<AccountItem>();
  User user;

  Future<bool> readDatabaseData() async{
    Map<String, dynamic> mapAccBalance = await DatabaseService(uid: user.uid).readUserData("AccountsBalance");
    if (mapAccBalance!=null){
      listAccounts.clear();
      mapAccBalance.forEach((key, value) {
        List<String> nameID = key.split("-");
        listAccounts.add(AccountItem(dummy: false, name:nameID[0], id: nameID[1],amount: value));
      });
    }

    Map<String, dynamic> mapTXShortcut = await DatabaseService(uid: user.uid).readUserData("TXShortcut");
    if (mapTXShortcut!=null){
      mapTXShortcut.forEach((key, value) {
        List<String> lvalue = value;
        print("mapTXShortcut: ${lvalue}");
      });
    }

    print("Read latest database data");
    if (mapAccBalance!=null && mapTXShortcut!=null)
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    /*if (listAccounts == null){
      //initialize list of accounts
      listAccounts.clear();
      g_mapAccBalance.forEach((key, value) {
        List<String> nameID = key.split("-");
        listAccounts.add(AccountItem(dummy: false, name:nameID[0], id: nameID[1],amount: value));
      });
    }

    if (g_mapTXShortcut!=null){
      g_mapTXShortcut.forEach((key, value) {
        List<String> lvalue = value;
        print("mapTXShortcut: ${lvalue}");
      });
    }*/



    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Transaction Activity"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: readDatabaseData(),
        builder: (context, snapshot){
          print("add_shortcut_item readDatabaseData snapshot: ${snapshot.data}");
          if (snapshot.hasData){
            if (premethod == null){
              premethod = listAccounts.first.name+listAccounts.first.id;
            }
            return GestureDetector(
              onTap: (){FocusScope.of(context).requestFocus(new FocusNode());},
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20,10,20,10),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.greenAccent[100],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: mType,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                labelText: typKey,
                                labelStyle: TextStyle(
                                  fontSize: head2size,
                                )
                            ),
                          ),
                          TextField(
                            controller: mAmount,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                labelText: amtKey,
                                labelStyle: TextStyle(
                                  fontSize: head2size,

                                )
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: RadioListTile(
                                  title: Text("Debit",style: TextStyle(fontSize: head2size, color: txtColor),),
                                  value: debit,
                                  activeColor: cioRdColor,
                                  groupValue: precinout,
                                  onChanged: (val){
                                    precinout = val;
                                    setState(() {});
                                  },
                                ),
                              ),
                              Flexible(
                                child: RadioListTile(
                                  title: Text("Credit",style: TextStyle(fontSize: head2size, color: txtColor),),
                                  value: credit,
                                  activeColor: cioRdColor,
                                  groupValue: precinout,
                                  onChanged: (val){
                                    precinout = val;
                                    setState(() {});
                                  },
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: DropdownButton(
                              dropdownColor: Colors.white,
                              isExpanded: true,
                              value: premethod,
                              items: listAccounts.map((account){
                                return DropdownMenuItem(
                                  child: Center(child: Text("${account.name}(${account.id})",)),
                                  value: account.name+account.id,
                                );
                              }).toList(),
                              onChanged: (method){
                                premethod = method;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Text("Confirm", style: TextStyle(color: Colors.grey[850]),),
                          color: Colors.purple[200],
                          onPressed: (){
                            Map<String, dynamic> txShortcut = Map<String, dynamic>();
                            txShortcut.addAll({mType.text: [
                              double.parse(mAmount.text).toStringAsFixed(2),
                              precinout,
                              premethod,
                            ]});
                            DatabaseService(uid: user.uid).updateTXShortcut(txShortcut);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }else{
            return Loading();
          }
        },
      ),
    );
  }
}
