import 'package:wealthmanager/data/constant_class.dart';
import 'package:wealthmanager/screens/add_precfg_tx_item.dart';
import 'package:wealthmanager/screens/home.dart';
import 'package:wealthmanager/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'package:wealthmanager/screens/edit_add_account.dart';
import 'package:wealthmanager/Services/auth.dart';
import 'package:wealthmanager/screens/sign_in.dart';
import 'package:wealthmanager/screens/authenticate.dart';
import 'package:wealthmanager/Services/database.dart';
import 'package:wealthmanager/screens/bottom_bar_nagivator.dart';

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  void backToWrapper(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null){
      return Authenticate();
    }else{
      return FutureBuilder(
        future: DatabaseService(uid: user.uid).checkUserDataValidity(),
        builder: (context,snapshot){
          if (snapshot.hasData){
            if (snapshot.data == false)
              return EditAddBankAcc(setup: true, backToWrapper: backToWrapper,);
            else{
              return BottomBarNavigator();
            }

          }else{
            return Loading();
          }
        },
      );
      /*if (!DatabaseService(uid: user.uid).checkUserDataValidity())
        return EditAddBankAcc(setup: true,);
      else
        return Home();*/
    }

  }
}
