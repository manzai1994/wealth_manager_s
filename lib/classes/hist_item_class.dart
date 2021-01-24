

import 'package:flutter/cupertino.dart';

class HistItem{
  String id;
  String date;
  String descr;
  String from;
  String to;
  String amount;

  HistItem({this.id,this.date,this.descr,this.from,this.to,this.amount});

  List<String> get list{
    return [id,date,descr,from,to,amount];
  }

  Map<String, dynamic> get mapBank{
    return {
      /*"ID": id,
      "Date": date,
      "Descr": descr,*/
      "From": from,
      "To": to,
      /*"Amount": amount,*/
    };
  }

}