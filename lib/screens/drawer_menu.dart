import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 300,
            color: Theme.of(context).primaryColor,
            child: Image(
              image: AssetImage('assets/images/app_icon.png'),
            )
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text("Transaction History"),
            onTap: (){
              //to ensure drawer pop away
              Navigator.pushReplacementNamed(context, '/main');
              Navigator.pushNamed(context, '/history');
            },
          ),
          /*ListTile(
            leading: Icon(Icons.credit_card),
            title: Text("Auto Credit Period"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.build),
            title: Text("Edit Transaction List"),
            onTap: (){},
          ),*/
          ListTile(
            leading: Icon(Icons.build),
            title: Text("Edit/Add Bank Account"),
            onTap: (){
              Navigator.pushReplacementNamed(context, '/main');
              Navigator.pushNamed(context, '/editAddBankAcc');
            },
          )
        ],
      ),
    );
  }
}
