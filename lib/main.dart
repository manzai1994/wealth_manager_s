import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens/add_precfg_tx_item.dart';
import 'screens/splash_screen.dart';
import 'screens/edit_add_account.dart';
import 'screens/tx_history.dart';
import 'screens/home.dart';
import 'screens/fb_listener.dart';
void main() async{
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(),
      '/fblistener': (context) => FBListener(),
      '/home': (context) => Home(),
      '/addItem': (context) => AddShortcut(),
      '/history': (context) => History(),
      '/editAddBankAcc': (context) => EditAddBankAcc(),
    },
  ));

}