import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/constant_class.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String thdString, amyString;
  Map<String,dynamic> thdJson, amyJson;
  List<dynamic> lIDs, lmy;
  List<List<dynamic>> txRowPart2DataFull, txFilteredData, txRowPart1Data, txRowPart2Data;
  List<String> columnPart1, columnToShow;
  String myFilter, accNumShowFilter;
  List<String> accsNumShowFilterList, accsShowFullList, accsShowFull, columnPart2, columnPart2wSpace;

  void extractThdJson(){
    thdString = txHistFileName.readAsStringSync();
    thdJson = jsonDecode(thdString);
    lIDs = thdJson.values.first;
    txRowPart1Data = List<List<dynamic>>();
    txRowPart2Data = List<List<dynamic>>();
    columnPart1 = List<String>();
    accsNumShowFilterList = List<String>();
    accsShowFullList = List<String>();
    accsShowFull = List<String>();

    //Convert transaction histories to "datarow" type
    for (int i = lIDs.length-1; i >= 0; i--){
      List<dynamic> txPart1RowData = List<dynamic>();
      List<dynamic> txPart2RowData = List<dynamic>();
      for (int j = 1; j < thdJson.length; j++){
        //ignore IDs since when j = 0, data = ID
        List<dynamic> dummy = thdJson[thdJson.keys.elementAt(j)];

        if (j <= 2){
          txPart1RowData.add(dummy[i]);
          if (!columnPart1.contains(thdJson.keys.elementAt(j))){
            columnPart1.add(thdJson.keys.elementAt(j));
          }
        }else if (j > 2){
          txPart2RowData.add(dummy[i]);
          if(!accsShowFullList.contains(thdJson.keys.elementAt(j))){
            accsShowFullList.add(thdJson.keys.elementAt(j));
          }
        }
      }
      txRowPart1Data.add(txPart1RowData);
      txRowPart2Data.add(txPart2RowData);
    }
    txRowPart2DataFull = List<List<dynamic>>.from(txRowPart2Data);

    for (int i = 1; i <= accsShowFullList.length; i++){
      //to find number of accounts available.
      String itemName;
      if (i > 2){
        itemName = "Show ${i} accounts";
      }else
        itemName = "Show ${i} account";
      accsNumShowFilterList.add(itemName);
    }
    accNumShowFilter = accsNumShowFilterList.last;
    accsShowFull.addAll(accsShowFullList);
  }
  void extractAmyJson(){
    amyString = actMYFileName.readAsStringSync();
    amyJson = jsonDecode(amyString);
    lmy = amyJson["MY"];
    myFilter = lmy.first;
  }

  List<String> TableTitle (List<String> columnPart1, columnPart2){
    List<String> columnToShow = List<String>();
    columnToShow.addAll(columnPart1);
    columnToShow.addAll(columnPart2);
    return columnToShow;
  }
  List<String> ColumnToShowSelList(List<String> columnPart2){
    List<String> columnPart2wSpace = List<String>();
    columnPart2.forEach((element) {
      columnPart2wSpace.add(element);
      if (columnPart2.indexOf(element)!=columnPart2.length-1)
        columnPart2wSpace.add("space");
    });
    return columnPart2wSpace;
  }
  List<List<dynamic>> txFilteredByDate(List<List<dynamic>> txFilteredData, String myFilter){
    List<List<dynamic>> txRowPart2Data = List<List<dynamic>>();
    if (myFilter != "Show All"){
      List<int> filterIndex = List<int>();
      txFilteredData.forEach((rowData) {
        if (!(rowData[0]).toString().contains(myFilter)){
          filterIndex.add(txFilteredData.indexOf(rowData));
        }
      });
      filterIndex = filterIndex.reversed.toList();
      filterIndex.forEach((index) {
        txFilteredData.removeAt(index);
      });
    }
    return txRowPart2Data;
  }
  List<List<dynamic>> txRowDataCombine(List<List<dynamic>> txRowPart1Data,
      List<List<dynamic>> txRowPart2Data){
    List<List<dynamic>> txFilteredData = List<List<dynamic>>();
    for (int i = 0; i < txRowPart1Data.length; i++){
      List<dynamic> txRowData = List<dynamic>();
      txRowData.addAll(txRowPart1Data[i]);
      txRowData.addAll(txRowPart2Data[i]);
      txFilteredData.add(txRowData);
    }
    return txFilteredData;
  }
  List<List<dynamic>> txFilteredByAccountRowPart2(List<List<dynamic>> txRowPart2DataFull, List<String> columnPart2){
    List<List<dynamic>> txRowPart2Data = List<List<dynamic>>();
    txRowPart2DataFull.forEach((element) {
      List<dynamic> temp = List<dynamic>();
      temp.addAll(element.sublist(0,columnPart2.length));
      txRowPart2Data.add(temp);
    });
    return txRowPart2Data;
  }
  List<String> titleFilter(List<String> accsNumShowFilterList, List<String> accsShowFull, String accNumShowFilter){
    List<String> columnPart2 = List<String>();
    for (int i = 0; i < accsNumShowFilterList.indexOf(accNumShowFilter)+1; i++){
      columnPart2.add(accsShowFull[i]);
    }
    return columnPart2;
  }

  @override
  void initState() {
    columnPart2 = List<String>();
    columnPart2wSpace = List<String>();
    columnToShow = List<String>();
    txFilteredData = List<List<dynamic>>();

    extractThdJson();
    extractAmyJson();
  }

  @override
  Widget build(BuildContext context) {

    columnPart2.clear();
    txRowPart2Data.clear();
    txFilteredData.clear();
    columnPart2wSpace.clear();
    columnToShow.clear();

    columnPart2 = titleFilter(accsNumShowFilterList, accsShowFull, accNumShowFilter);
    txRowPart2Data.addAll(txFilteredByAccountRowPart2(txRowPart2DataFull, columnPart2));
    txFilteredData.addAll(txRowDataCombine(txRowPart1Data, txRowPart2Data));
    txFilteredData.addAll(txFilteredByDate(txFilteredData, myFilter));
    columnToShow.addAll(TableTitle(columnPart1,columnPart2));
    columnPart2wSpace.addAll(ColumnToShowSelList(columnPart2));

    return WillPopScope(
      onWillPop: () async{
        Navigator.removeRouteBelow(context, ModalRoute.of(context));
        Navigator.popAndPushNamed(context, '/main');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Transaction History"),),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: DropdownButton(
                        value: myFilter,
                        isExpanded: true,
                        items: lmy.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(fontSize: head2size)),
                          );
                        }).toList(),
                        onChanged: (value){
                          setState(() {
                            myFilter = value;
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
                          });
                        },),
                    )
                  ],
                ),
                Row(
                  children: columnPart2wSpace.map((account) {
                    if (columnPart2wSpace.indexOf(account)%2==0)
                      return Expanded(
                        flex: 6,
                        child: DropdownButton(
                          value: account,
                          isExpanded: true,
                          items: accsShowFullList.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: TextStyle(fontSize: head3size)),
                            );
                          }).toList(),
                          onChanged: (value){
                            setState(() {
                              int iSel = columnPart2.indexOf(account);
                              String holdAcc = accsShowFull[iSel];
                              int iReplace = accsShowFull.indexOf(value);
                              accsShowFull[iSel] = value;
                              accsShowFull[iReplace] = holdAcc;

                              for (int i = 0; i < txRowPart2DataFull.length; i++){
                                dynamic holdAmt = txRowPart2DataFull[i][iSel];
                                txRowPart2DataFull[i][iSel] = txRowPart2DataFull[i][iReplace];
                                txRowPart2DataFull[i][iReplace] = holdAmt;
                              }
                            });
                          },
                        ),
                      );
                    else
                      return Expanded(
                        flex: 1,
                        child: SizedBox(width: 5,),
                      );
                  }).toList(),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dataRowHeight: 30,
                    columnSpacing: 8,
                    columns: columnToShow.map((title) {
                      int iColumn = columnToShow.indexOf(title);
                      bool isNum = false;
                      String newTitle = title;
                      if(title.contains(" - ")){
                        String name = title.split(" - ")[0];
                        String id = title.split(" - ")[1];
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
                    rows: txFilteredData.map((rowData) {
                      int indexTitle = 0;
                      int indexRow = txFilteredData.indexOf(rowData);
                      Color rowColor = Colors.white;
                      if (indexRow %2 == 0)
                        rowColor = Colors.blue[100];
                      return DataRow(
                          color: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                            return rowColor;
                          }),
                          cells: rowData.map((data) {
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
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
