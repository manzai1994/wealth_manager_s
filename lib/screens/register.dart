import 'package:flutter/material.dart';
import 'package:wealthmanager/Services/auth.dart';
import 'package:email_validator/email_validator.dart';


class Register extends StatelessWidget {
  final formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String email, password;

  final Function toggleView;
  Register({this.toggleView});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
        actions: [
          FlatButton(
            child: Text("Sign In"),
            onPressed: (){
              toggleView();
            },
          )
        ],
      ),
      body: Center(
        child: Form(
          key: formkey,
          child: Container(
            padding: EdgeInsets.all(50),
            child: Wrap(
              runSpacing: 10,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (email){
                    this.email = email;
                    return EmailValidator.validate(email)? null: "Incorrect Format";
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Password"),
                  keyboardType: TextInputType.text,
                  onChanged: (password){
                    this.password = password;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Confirm Password"),
                  keyboardType: TextInputType.text,
                  validator: (cPassword){
                    if (cPassword != password)
                      return "password is not the same";
                    else if (cPassword.length < 6)
                      return "Password must be more than 6 characters";
                    else
                      return null;
                  },
                ),
                RaisedButton(
                  child: Text("Register"),
                  onPressed: () async{
                    if (formkey.currentState.validate()){
                      dynamic user = await _auth.registerEmailPassword(email, password);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
