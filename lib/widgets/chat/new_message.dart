import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget{
  @override
  State<NewMessage> createState() {
    return NewMessageState();
  }
}
class NewMessageState extends State<NewMessage>{
  String _Message = "";
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(color: Color.fromARGB(190, 250, 200, 110),
    height: 55,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(child: TextField(
          decoration: InputDecoration(
              labelText: "Send a Message"
          ),
          onChanged: (value){
            setState(() {
              _Message = value;
            });
          },
          controller: _controller,
        )
        ),
        IconButton(
          icon: Icon(
              Icons.send
          ),
          onPressed: _Message.trim().isNotEmpty ? (){
            FocusScope.of(context).unfocus();
            _controller.clear();
            FirebaseFirestore.instance.collection("chat").add({
              "text" : _Message,
              "createdAt" : Timestamp.now(),
              "uid" : FirebaseAuth.instance.currentUser!.uid
            });
            _Message = "";
          } : null,
        )
      ],
    ),
    );
  }
}