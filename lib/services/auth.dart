import 'package:firebase_auth/firebase_auth.dart';
import 'package:wealthmanager/Services/database.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;


  Stream<User> get user{
    return _auth.authStateChanges();
  }

  Future registerEmailPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      print("Register successful");
      return user;
    }catch(e){
      print("Register Error: $e");
      return null;
    }
  }

  //Sign in Anon
  /*Future signInAnon() async{
    try{
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      await DatabaseService(uid: user.uid).updateUserData("0", "0");
      return user;
    }catch(e){
      print("Sign in error: ${e.toString()}");
      return null;
    }
  }*/

  Future signInEmailPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      print("Sign In successful");
      return user;
    }catch(e){
      print("Sign in error: ${e.toString()}");
      return null;
    }
  }

  Future signOut(){
    _auth.signOut();
  }

}