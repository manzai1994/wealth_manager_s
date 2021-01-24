
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wealthmanager/screens/loading.dart';
import 'package:wealthmanager/services/database.dart';
import 'package:wealthmanager/data/constant_class.dart';
import 'package:wealthmanager/classes/account_item_class.dart';
import 'package:wealthmanager/classes/hist_item_class.dart';



class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<dynamic> monthYears = List<dynamic>();
  User user;
  String monthYearFilter;
  List<String> accsNumShowFilterList = List<String>();
  String accNumShowFilter;
  List<HistItem> listHists = List<HistItem>();
  List<String> listAccountNames = List<String>();
  List<String> listAccountNamesShow = List<String>();
  List<String> tableTitle;

  bool skip = false;

  Future extractHistory() async{
    if (!skip){
      skip = true;
      try{
        Map<String, dynamic> histInfo = await DatabaseService(uid: user.uid).readHistInfo();
        monthYears.clear();
        monthYears = histInfo["collections"];
        monthYears = monthYears.reversed.toList();
        if (monthYearFilter == null){
          monthYearFilter = monthYears.first;
        }
        accsNumShowFilterList.clear();

        Map<String, dynamic> mapAccBalance = await DatabaseService(uid: user.uid).readUserData("AccountsBalance");
        print("mapAccBalance: ${mapAccBalance}");
        //extract map of accounts
        if (mapAccBalance!=null){
          listAccountNames.clear();
          mapAccBalance.forEach((key, value) {
            List<String> nameID = key.split("-");
            listAccountNames.add("${nameID[0]}-${nameID[1]}");
          });
          listAccountNamesShow = List<String>.from(listAccountNames);
        }


        for(int i = 0; i < listAccountNames.length; i++){
          String filter;
          if (i < 1){
            filter = "Show ${i+1} account";
          }else{
            filter = "Show ${i+1} accounts";
          }
          accsNumShowFilterList.add(filter);
        }

        if (accNumShowFilter == null){
          accNumShowFilter = accsNumShowFilterList.last;
        }

        listHists.clear();
        List<dynamic> temp = await DatabaseService(uid: user.uid).readHistAll(monthYears);
        temp.forEach((element) {
          Map<String, dynamic> histItem = element;
          listHists.add(HistItem(
            id: histItem["id"],
            date: histItem["date"],
            descr: histItem["descr"],
            from: histItem["from"],
            to: histItem["to"],
            amount: histItem["amount"]
          ));
        });
        listHists = listHists.reversed.toList();
        listHists.forEach((element) {
          print("listHists: ${element.id}, ${element.date}, ${element.descr}, ${element.from}, ${element.to}, ${element.amount}");
        });

        return true;
      }catch(e){
        return false;
      }
    }else{
      return false;
    }

  }
  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction History"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: extractHistory(),
        builder: (context, snapshot){
          if(snapshot.hasData && (snapshot.connectionState == ConnectionState.done)){
            print("listAccountNames: ${listAccountNames.length}");
            print("listAccountNamesShow: ${listAccountNamesShow.length}");

            //update table title
            tableTitle = List<String>();
            tableTitle.addAll([
              "Date",
              "Description"
            ]);
            tableTitle.addAll(listAccountNamesShow);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: DropdownButton(
                            value: monthYearFilter,
                            isExpanded: true,
                            items: monthYears.map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(fontSize: head2size)),
                              );
                            }).toList(),
                            onChanged: (value){
                              setState(() {
                                monthYearFilter = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10,),
                        Flexible(
                          child: DropdownButton(
                            value: accNumShowFilter,
                            isExpanded: true,
                            items: accsNumShowFilterList.map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(fontSize: head2size)),
                              );
                            }).toList(),
                            onChanged: (value){
                              setState(() {
                                accNumShowFilter = value;
                                listAccountNamesShow.clear();
                                for (int i = 0; i < accsNumShowFilterList.indexOf(accNumShowFilter)+1; i++){
                                  listAccountNamesShow.add(listAccountNames[i]);
                                }
                              });
                            },),
                        )
                      ],
                    ),
                    Row(
                      children: listAccountNamesShow.map((account) {
                        return Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 5, right: 5),
                              child: DropdownButton(
                                value: account,
                                isExpanded: true,
                                items: listAccountNames.map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: TextStyle(fontSize: head3size)),
                                  );
                                }).toList(),
                                onChanged: (value){
                                  setState(() {
                                    listAccountNames.forEach((element) {
                                      print("before listAccountNames: $element");
                                    });
                                    int iSel = listAccountNames.indexOf(account);
                                    String holdAcc = listAccountNames[iSel];
                                    int iReplace = listAccountNames.indexOf(value);
                                    listAccountNames[iSel] = value;
                                    listAccountNames[iReplace] = holdAcc;
                                    listAccountNames.forEach((element) {
                                      print("after listAccountNames: $element");
                                    });
                                    listAccountNamesShow.clear();
                                    for (int i = 0; i < accsNumShowFilterList.indexOf(accNumShowFilter)+1; i++){
                                      listAccountNamesShow.add(listAccountNames[i]);
                                    }
                                    /*for (int i = 0; i < txRowPart2DataFull.length; i++){
                                      dynamic holdAmt = txRowPart2DataFull[i][iSel];
                                      txRowPart2DataFull[i][iSel] = txRowPart2DataFull[i][iReplace];
                                      txRowPart2DataFull[i][iReplace] = holdAmt;
                                    }*/
                                  });
                                },
                              ),
                            ),
                          );
                      }).toList(),
                    ),//TODO TABLE
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        dataRowHeight: 30,
                        columnSpacing: 8,
                        columns: tableTitle.map((title) {
                          int iColumn = tableTitle.indexOf(title);
                          bool isNum = false;
                          String newTitle = title;
                          if(title.contains("-")){
                            String name = title.split("-")[0];
                            String id = title.split("-")[1];
                            newTitle = "$name\n($id)";
                          }

                          if (iColumn > 1){
                            isNum = true;
                          }
                          return DataColumn(
                            numeric: isNum,
                            label: Text(newTitle, style: TextStyle(fontSize: head2size), textAlign: TextAlign.center,),
                          );
                        }).toList(),
                        rows: listHists.map((histItem) {
                          List<String> dataRow = List<String>();
                          List<String> hil = histItem.list;
                          Map<String, dynamic> himb = histItem.mapBank;

                          for (int i = 0; i < tableTitle.length; i++){
                            String title = tableTitle[i];
                            if (i < 2){
                              dataRow.add(hil[i+1]);
                            }else{
                              bool found = false;
                              himb.forEach((key, value) {
                                if (key == "To" && value == title){
                                  found = true;
                                  dataRow.add(hil[5]);
                                }else if (key == "From" && value == title){
                                  dataRow.add((double.parse(hil[5])*-1).toStringAsFixed(2));
                                  found = true;
                                }
                              });
                              if (!found){
                                dataRow.add("0.00");
                              }
                            }
                          }
                          int indexTitle = 0;
                          int indexRow = listHists.indexOf(histItem);
                          Color rowColor = Colors.white;
                          if (indexRow %2 == 0)
                            rowColor = Colors.blue[100];
                          return DataRow(
                              color: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                return rowColor;
                              }),
                              cells: dataRow.map((data) {
                                double width = 50;
                                Color colorAmt = Colors.black;
                                FontWeight fw = FontWeight.normal;
                                double fs = head3size;
                                if (indexTitle == 1)
                                  width = 150;
                                TextAlign txAlign = TextAlign.left;
                                if (indexTitle > 1){
                                  txAlign = TextAlign.right;
                                  if (double.parse(data)>0){
                                    fw = FontWeight.bold;
                                    colorAmt = Colors.green[800];
                                  }
                                  else if (double.parse(data)<0){
                                    fw = FontWeight.bold;
                                    colorAmt = Colors.red;
                                  }
                                }else if (indexTitle == 0)
                                  fs = head4size;

                                indexTitle++;
                                return DataCell(Container(
                                  width: width,
                                  child: Text(data, style: TextStyle(fontSize: fs, color: colorAmt,fontWeight: fw), textAlign: txAlign,),
                                ));
                              }).toList()); 
                          
                          /*DataRow(
                            cells: dataRow.map((cell) {
                              return DataCell(Text("${cell}"));
                            }).toList(),
                          );*/
                        }).toList(),
                      ),
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
