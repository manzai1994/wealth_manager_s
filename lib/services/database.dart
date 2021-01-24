import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wealthmanager/classes/account_item_class.dart';

class DatabaseService{

  final String uid;
  CollectionReference fbInstance;
  DatabaseService({this.uid}){
    this.fbInstance = FirebaseFirestore.instance.collection(uid.toString());
  }

  bool isRecordExist = false;

  //collection reference of User Data Collection
  //final CollectionReference userDataCollection = FirebaseFirestore.instance.collection('CashFlow');
  /*Future testing() async{
    userDataCollection.doc(uid).collection('TXShortcut').doc(uid).set({
      "1": "tiger",
      "2": "lion",
      "3": "cat fish",
      "4": "fish",
      "5": "dog",
    });
  }*/

  Future<Map<String,dynamic>> readUserData(String Collection) async{
    try{
      DocumentSnapshot ds = await fbInstance.doc(Collection).get();
      return ds.data();
    }catch(e){
      return null;
    }
  }
  Future<Map<String,dynamic>> readHist(String monthYear) async{
    try{
      DocumentSnapshot ds = await fbInstance.doc("History").collection(monthYear).doc(uid).get();
      return ds.data();
    }catch(e){
      print("readHist error: $e");
      return null;
    }
  }
  Future<List<dynamic>> readHistAll(List<dynamic> monthYears) async{
    try{
      Map<String, dynamic> histAll = Map<String, dynamic>();

      for (int i = 0; i < monthYears.length; i++){
        String monthYear = monthYears[i];
        Map<String, dynamic> histMY = await readHist(monthYear);
        histAll.addAll(histMY);
      }
      List<dynamic> test = List<dynamic>();
      List<dynamic> test2 = List<dynamic>();
      histAll.forEach((key, value) {
        test.add(value);
        test.forEach((element) {
          test2 = element;
        });
      });
      return test2;
    }catch(e){
      print("readHistAll error: $e");
      return null;
    }
  }
  Future<Map<String, dynamic>> readHistInfo() async{
    try{
      DocumentSnapshot ds1 = await fbInstance.doc("History").get();
      return ds1.data();
    }catch(e){
      return null;
    }
  }
  Future<bool> checkUserDataValidity() async{
    try{
      DocumentSnapshot docSnaphot = await fbInstance.doc("AccountsBalance").get();
      isRecordExist = docSnaphot.data().isEmpty;
      print("checkUserDataValidity: ${docSnaphot.exists}");
      return true;
    }catch(e){
      print("Error checking user record $e");
      return false;
    }
  }

  Future updateAccountsAll(List<AccountItem> listAccounts) async{
    /*Map<String, dynamic> accBalance = Map<String,dynamic>();
    listAccounts.forEach((account) {
      String nameID = "${account.name}-${account.id}";
      String balance = account.amount;
      accBalance.addAll({nameID: balance});
    });*/
    //print("uid: $uid");
    for (int i = 0; i < listAccounts.length; i++){
      await updateAccount(listAccounts[i]);
    }
    return true;
    // return await fbInstance.doc("AccountsBalance").update({"Accounts": FieldValue.arrayUnion([accBalance])});
  }
  Future createAccountsAll (List<AccountItem> listAccounts) async{
    /*Map<String, dynamic> accBalance = Map<String,dynamic>();
    listAccounts.forEach((account) {
      String nameID = "${account.name}-${account.id}";
      String balance = account.amount;
      accBalance.addAll({nameID: balance});
    });*/

    for (int i = 0; i < listAccounts.length; i++){
      try{
        await updateAccount(listAccounts[i]);
      }catch(e){
        await createAccount(listAccounts[i]);
      }

    }
    //print("uid: $uid");
    //return await fbInstance.doc("AccountsBalance").set({"Accounts": FieldValue.arrayUnion([accBalance])});
    return true;
  }
  Future createAccount(AccountItem account) async{
    Map<String, dynamic> accBalance = Map<String,dynamic>();
    String nameID = "${account.name}-${account.id}";
    String balance = account.amount;
    accBalance.addAll({nameID: balance});
    return await fbInstance.doc("AccountsBalance").set(accBalance);
    /*return await fbInstance.doc("AccountsBalance").set({"Accounts": FieldValue.arrayUnion([accBalance])});*/
  }
  Future updateAccount(AccountItem account) async{
    Map<String, dynamic> accBalance = Map<String,dynamic>();
    String nameID = "${account.name}-${account.id}";
    String balance = account.amount;
    accBalance.addAll({nameID: balance});
    return await fbInstance.doc("AccountsBalance").update(accBalance);
    /*await deleteAccount(account);
    return await fbInstance.doc("AccountsBalance").update({"Accounts": FieldValue.arrayUnion([accBalance])});*/
  }
  Future deleteAccount (AccountItem account) async{
    Map<String, dynamic> accDelete = {"${account.name}-${account.id}": FieldValue.delete()};
    //Map<String, dynamic> accDelete = {"${account.name}-${account.id}": account.amount};
    /*DocumentSnapshot ds = await fbInstance.doc("AccountsBalance").get();
    print("read ds account uid(${uid}): ${ds.data()}");*/
    //return await fbInstance.doc("AccountsBalance").update({"Accounts": FieldValue.arrayRemove([accDelete])}).whenComplete(() => print("deleted account"));
    return await fbInstance.doc("AccountsBalance").update(accDelete).whenComplete(() => print("deleted account"));
  }

  Future updateTXShortcut(Map<String, dynamic> shortcuts) async{
    //{Type name: [ amount, precinout, premethod ]}
    return await fbInstance.doc("TXShortcuts").update(shortcuts);
  }
  Future createTXShortcut(Map<String, dynamic> shortcuts) async{
    //{Type name: [ amount, precinout, premethod ]}
    return await fbInstance.doc("TXShortcuts").set(shortcuts);
  }

  Future createHist(Map<String, dynamic> hist) async{
    String monthYear = hist["id"].toString().split("-")[0];
    String month = monthYear.split(" ")[0];
    String year = monthYear.split(" ")[1];

    return await fbInstance.doc("History").collection(monthYear).doc(uid).set({
      "histItems": FieldValue.arrayUnion([{
        "id": hist["id"],
        "date": hist["date"],
        "descr": hist["descr"],
        "to": hist["to"],
        "from": hist["from"],
        "amount": hist["amount"]
      }]),
    });
  }
  Future updateHist(Map<String, dynamic> hist) async{
    String monthYear = hist["id"].toString().split("-")[0];
    String month = monthYear.split(" ")[0];
    String year = monthYear.split(" ")[1];

    return await fbInstance.doc("History").collection(monthYear).doc(uid).update({
      "histItems": FieldValue.arrayUnion([{
        "id": hist["id"],
        "date": hist["date"],
        "descr": hist["descr"],
        "to": hist["to"],
        "from": hist["from"],
        "amount": hist["amount"]
      }]),
    });
  }
  Future createUpdateHist(Map<String, dynamic> hist) async{

    try{
      await updateHist(hist);
      await logLastID(hist["id"]);
      await logHistCollection(hist["id"]);
      /*print("updateHist: ${hist["to"]}");
      await logLastID(hist["id"]);
      return true;*/
    }catch(e){
      await createHist(hist);
      await logLastID(hist["id"]);
      await logHistCollection(hist["id"]);
      /*print("createHist: ${hist["to"]}");
      await logLastID(hist["id"]);
      return false;*/
    }

  }

  Future logLastID(String id) async{
    String index = id.split("-")[1];
    try{
      return await fbInstance.doc("History").update({
        "lastID" : index,
      });
    }catch(e){
      return await fbInstance.doc("History").set({
        "lastID" : index,
      });
    }
  }
  Future logHistCollection(String id) async{
    String monthYear = id.split("-")[0];
    try{
      return await fbInstance.doc("History").update({
        "collections" : FieldValue.arrayUnion([monthYear]),
      });
    }catch(e){
      return await fbInstance.doc("History").set({
        "collections" : FieldValue.arrayUnion([monthYear]),
      });
    }
  }

}