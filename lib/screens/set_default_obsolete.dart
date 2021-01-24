import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wealthmanager/data/constant_class.dart';
import 'package:intl/intl.dart';
import '../classes/account_item_class.dart';


@Deprecated("Use [edit_add_account.dart] instead for adding and editing account")
class SetDefault extends StatefulWidget {
  @override
  _SetDefaultState createState() => _SetDefaultState();
}

class _SetDefaultState extends State<SetDefault> {
  TextEditingController mBankName = TextEditingController();
  TextEditingController mBankID = TextEditingController();
  List<TextEditingController> mLAccountItems = List<TextEditingController>();
  List<AccountItem> lAccountItems = [AccountItem(name: "Cash", id: "RM",)];

  @override
  Widget build(BuildContext context) {
    String accSummData = accSummFileName.readAsStringSync();
    Map<String,dynamic> asdJson = jsonDecode(accSummData);

    String txHistData = txHistFileName.readAsStringSync();
    Map<String,dynamic> thdJson = jsonDecode(txHistData);

    String actMYData = actMYFileName.readAsStringSync();
    Map<String,dynamic> amyJson = json.decode(actMYData);
    List<dynamic> lamy = amyJson[my];

    mLAccountItems.clear();

    return GestureDetector(
      onTap: (){FocusScope.of(context).requestFocus(new FocusNode());},
      child: Scaffold(
        appBar: AppBar(
          title: Text("Setting Up Your Profile"),
          centerTitle: true,
        ),
        body: Builder(
          builder: (BuildContext context){
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Enter Your Current Balance in RM",
                      style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                    ),
                    Column(
                      children: lAccountItems.map((accountItem) {
                        int i = lAccountItems.indexOf(accountItem);

                        mLAccountItems.add(TextEditingController());
                        return TextField(
                          controller: mLAccountItems[i],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "${accountItem.name} - ${accountItem.id}",
                            labelStyle: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        );
                        //return Text("testing");
                      }).toList(),
                    ),
                    RaisedButton(
                      child: Text("Confirm"),
                      onPressed: (){
                        //add bank balance to AccountItem
                        bool complete = true;
                        for (int i = 0; i < mLAccountItems.length; i++){
                          if (mLAccountItems[i].text.trim() == ""){
                            complete = false;
                            break;
                          }
                        }

                        if (complete){
                          lAccountItems.forEach((element) {
                            element.amount = mLAccountItems[lAccountItems.indexOf(element)].text.trim();
                          });
                          //add cash and banks amounts to asdJson & thdJson
                          lAccountItems.forEach((e) {
                            String key = "${e.name} - ${e.id}";
                            asdJson[key] = double.parse(e.amount).toStringAsFixed(2);
                            thdJson[key] = [double.parse(e.amount).toStringAsFixed(2)];
                          });

                          //write cash & banks values to Summary file
                          accSummFileName.writeAsStringSync(jsonEncode(asdJson));

                          final DateTime now = DateTime.now();
                          final DateFormat formatter = DateFormat('dd\-MMM yy\nhh:mm a');
                          final String formatted = formatter.format(now);

                          thdJson["ID"] = ["${formatted.substring(3,9)} - 1"];
                          thdJson[date] = [formatted];
                          thdJson[descr] = ["Record Cash & Bank Value"];

                          //log TX record to Transaction History file
                          txHistFileName.writeAsStringSync(jsonEncode(thdJson));

                          String month = formatted.substring(3,6);
                          String year = formatted.substring(7,9);
                          lamy.add("$month $year");
                          amyJson[my] = lamy;
                          actMYFileName.writeAsStringSync(jsonEncode(amyJson));
                          Navigator.pushReplacementNamed(context, '/main');
                        }else{
                          final snackBar = SnackBar(
                            content: Text("Something is missing."),
                            duration: Duration(seconds: 2),
                          );
                          // Find the Scaffold in the widget tree and use
                          Scaffold.of(context).showSnackBar(snackBar);
                        }

                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text("Bank Account"),
          onPressed: (){
            showDialog(
                context: context,
                child: AlertDialog(
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: mBankName,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Bank Name:",
                            labelStyle: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        TextField(
                          controller: mBankID,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Last 4-digit on Card:",
                            labelStyle: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    MaterialButton(
                      child: Text("Cancel"),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                    MaterialButton(
                      child: Text("Confirm"),
                      onPressed: (){
                        lAccountItems.add(AccountItem(name: mBankName.text.trim(), id: mBankID.text.trim()));
                        mBankName.text = "";
                        mBankID.text = "";
                        setState(() {});
                      },
                    ),
                  ],
                )
            );
          },
        ),
      ),
    );
  }
}
