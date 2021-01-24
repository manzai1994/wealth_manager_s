import 'package:flutter/material.dart';
import 'package:wealthmanager/classes/shortcut_item_class.dart';
import 'package:wealthmanager/data/constant_class.dart';
import 'package:wealthmanager/classes/account_item_class.dart';

class TransactionWidget extends StatefulWidget {
  ShortcutItem TX;
  List<ShortcutItem> shortcuts;

  List<AccountItem> allAccounts = List<AccountItem>();
  AccountItem selAccount;
  String precinout;
  ValueChanged onChanged;
  TextEditingController mAmount, mNote;
  TransactionWidget({this.TX, this.shortcuts, this.mAmount, this.mNote, this.precinout, this.allAccounts, this.selAccount, this.onChanged});

  Map<String, dynamic> msg = Map<String, dynamic>();

  @override
  _TransactionWidgetState createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(10),
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
      child: Column(
        children: <Widget>[
          TextField(
            controller: widget.mAmount,
            decoration: InputDecoration(
                labelText: 'Amount: RM',
                labelStyle: TextStyle(
                  fontSize: head2size,
                )
            ),
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: head2size,
            ),
          ),
          /*Row(
            children: <Widget>[
              Flexible(
                child: RadioListTile(
                  title: Text("${allAccounts.first.name}\n(${allAccounts.first.id})",style: TextStyle(fontSize: head2size, color: txtColor),),
                  value: "${allAccounts.first.name} - ${allAccounts.first.id}",
                  activeColor: mtdRdColor,
                  groupValue: premethod,
                  onChanged: (val){
                    premethod = val;
                    updateOnChangedReturnValue();
                  },
                ),
              ),
              Flexible(
                child: RadioListTile(
                  title: Text("${selBank.name}\n(${selBank.id})",style: TextStyle(fontSize: head2size, color: txtColor),),
                  value: "${selBank.name} - ${selBank.id}",
                  toggleable: true,
                  activeColor: mtdRdColor,
                  groupValue: premethod,
                  onChanged: (val){

                    if (bankAccounts.length > 1){
                      showDialog(
                          context: context,
                          builder: (context){
                            return BankSelectionDialog(
                                bankAccounts: bankAccounts,
                                selBank: selBank,
                                onChangedBank: (account){
                                  premethod = "${account.name} - ${account.id}";
                                  selBank = account;
                                  onChangedBank(account);
                                }
                            );
                          }
                      );
                    }else if(val == null){
                      premethod = "${selBank.name} - ${selBank.id}";
                    }else{
                      premethod = val;
                    }
                    updateOnChangedReturnValue();
                  },
                ),
              ),
            ],
          ),*/
          Row(
            children: <Widget>[
              Flexible(
                child: RadioListTile(
                  title: Text("Debit",style: TextStyle(fontSize: head2size, color: txtColor),),
                  value: debit,
                  activeColor: cioRdColor,
                  groupValue: widget.precinout,
                  onChanged: (val){
                    widget.msg = {"precinout": val};
                    widget.onChanged(widget.msg);
                  },
                ),
              ),
              Flexible(
                child: RadioListTile(
                  title: Text("Credit",style: TextStyle(fontSize: head2size, color: txtColor),),
                  value: credit,
                  activeColor: cioRdColor,
                  groupValue: widget.precinout,
                  onChanged: (val){
                    widget.msg = {"precinout": val};
                    widget.onChanged(widget.msg);
                  },
                ),
              )
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: DropdownButton(
              dropdownColor: Colors.white,
              isExpanded: true,
              value: widget.selAccount,
              items: widget.allAccounts.map((account){
                return DropdownMenuItem(
                  child: Center(child: Text("${account.name}(${account.id}) - RM ${account.amount}",)),
                  value: account,
                );
              }).toList(),
              onChanged: (account){
                widget.msg = {"selAccount": account};
                widget.onChanged(widget.msg);
              },
            ),
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
              value: widget.TX,
              items: widget.shortcuts.map((shortcut){
                return DropdownMenuItem(
                  value: shortcut,
                  child: Center(child: Text("${shortcut.type}")),
                );
              }).toList(),
              onChanged: (shortcut){
                widget.msg = {"type": shortcut};
                widget.onChanged(widget.msg);
              },
            ),
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: widget.mNote,
                  decoration: InputDecoration(
                      labelText: 'Note:',
                      labelStyle: TextStyle(
                        fontSize: head2size,
                      )
                  ),
                  style: TextStyle(
                    fontSize: head2size,
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: 30,),
                  MaterialButton(
                    child: Text("Clear Note",style: TextStyle(
                      color: txtColor,),),
                    onPressed: (){
                      widget.mNote.clear();
                      //updateOnChangedReturnValue();
                    },
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 20,),
          /*Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Text("Confirm", style: TextStyle(color: Colors.grey[850]),),
                color: Colors.purple[200],
                onPressed: (){
                  widget.extract_Transaction_Widget_Data();
                  final snackBar = SnackBar(
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
                                    );
                                    // Find the Scaffold in the widget tree and use
                                    // it to show a SnackBar.
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              )
            ],
          )*/
        ],
      ),
    );
  }
}
