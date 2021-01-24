import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wealthmanager/Services/auth.dart';
import 'package:wealthmanager/data/constant_class.dart';
import 'package:wealthmanager/data/app_settings.config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wealthmanager/screens/loading.dart';
import 'fb_listener.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /*Future<void> _loadFiles() async{
    await Firebase.initializeApp();
    //Navigator.pushReplacementNamed(context, '/fblistener');
  }

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }*/

  @override
  Widget build(BuildContext context) {


    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot){
        if (snapshot.hasData){
          final AuthService _auth = AuthService();
          //_auth.signOut();
          return FBListener();
        }

        else
          return Loading();
      },
    );
  }
}

