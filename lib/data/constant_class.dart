import 'package:flutter/material.dart';
import 'dart:io';

String cash = "Cash", bank = "Bank", debit = "Debit", credit = "Credit";

String typKey = "Type", amtKey = "Amount", mtdKey = "Method", cioKey = "Cinout";

String date = "Date", descr = "Description";

String my = "MY";

double head1size = 30, head2size = 14, head3size = 11, head4size = 9;

Color txtColor = Colors.grey[700],
    txtTtlColor = Colors.grey[800],
    mtdRdColor = Colors.deepPurple,
    cioRdColor = Colors.blue,
    selBankColor = Colors.blue[800],
    transIconColor = Colors.green[600],
    transIconBackColor = Colors.blue[100],
    negativeColor = Colors.red[900],
    positiveColor = Colors.green[800]
;

List<File> fl;
File txCfgFileName = fl[0];
File accSummFileName = fl[1];
File txHistFileName = fl[2];
File actMYFileName = fl[3];

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}