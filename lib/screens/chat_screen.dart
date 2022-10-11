import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chatapp/widgets/chat/messages.dart';
import 'package:firebase_chatapp/widgets/chat/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Theme.of(context).backgroundColor,appBar: AppBar(
      backgroundColor: Color.fromARGB(190, 250, 200, 110),
      title: Text("Lets Chat"),
      actions: <Widget>[
        DropdownButton(underline: Container(),icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).primaryIconTheme.copyWith(color: Colors.black).color,
        ),
            items: [
          DropdownMenuItem(value: "logout",
              child: Container(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.logout,
                  color: Theme.of(context).primaryIconTheme.copyWith(color: Colors.black).color,
                ),
                SizedBox(width: 8,)
                ,Text("Logout")
              ],
            ),
          ))
        ], onChanged: (iteMIdentifier){
          if(iteMIdentifier == "logout"){
            FirebaseAuth.instance.signOut();
          }
            })
      ],
    ),
      body: Column(
        children: <Widget>[
          Expanded(child: Messages()),
          NewMessage()
        ],
      ),
    );
  }
}