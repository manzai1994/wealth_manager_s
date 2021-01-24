import 'package:flutter/material.dart';
import 'package:wealthmanager/Services/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:wealthmanager/screens/loading.dart';


class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formkey = GlobalKey<FormState>();

  final AuthService _auth = AuthService();

  String email, password;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading? Loading(): Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        centerTitle: true,
        actions: [
          FlatButton(
            child: Text("Register"),
            onPressed: (){
              widget.toggleView();
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
                  validator: (password){
                    this.password = password;
                    return password.length > 6? null: "Password must have at least 6 characters";
                  },
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: RaisedButton(
                    child: Text("Sign In"),
                    onPressed: () async{
                      if (formkey.currentState.validate()){
                        setState(() {
                          loading = true;
                        });
                        await _auth.signInEmailPassword(email, password);
                        setState(() {
                          loading = false;
                        });
                      }
                    },
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
