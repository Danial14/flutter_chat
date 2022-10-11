import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget{
 late String _Message, _userUid, _iMageUrl = "";
  MessageBubble(String Message, String userUid){
    _Message = Message;
    _userUid = userUid;
  }
  Future<String> getUserNaMe() async{
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance.collection("users").doc(_userUid).get();
    return data.data()!["username"];
  }
  Future<String> _getImageUrl() async {
    final data = await FirebaseFirestore.instance.collection("users").doc(_userUid).get();
    return data.data()!["iMageUrl"];
  }
  void _setIMageUrl() async{
    _iMageUrl = await _getImageUrl();
  }
  @override
  Widget build(BuildContext context) {
    _setIMageUrl();
    return FutureBuilder(builder: (ctx, snapshot){
      if(snapshot.connectionState == ConnectionState.done){
        print("Messagebubbles: ${snapshot.data}");
        return Stack(children: <Widget>[
          Row(
            mainAxisAlignment: FirebaseAuth.instance.currentUser!.uid == _userUid ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 100,
                child: Column(
                  crossAxisAlignment: FirebaseAuth.instance.currentUser!.uid == _userUid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    if(FirebaseAuth.instance.currentUser!.uid == _userUid)
                      Text(snapshot.data.toString()),
                    Text(_Message),
                    if(FirebaseAuth.instance.currentUser!.uid != _userUid)
                      Text(snapshot.data.toString()),
                  ],
                ),
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: FirebaseAuth.instance.currentUser!.uid == _userUid ? const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomRight: Radius.circular(15)) : const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                    border: Border.all(style: BorderStyle.solid),
                    color: FirebaseAuth.instance.currentUser!.uid == _userUid ? Colors.amberAccent : Colors.blue
                ),
              )
            ],
          ),
          Positioned(child: CircleAvatar(backgroundImage: NetworkImage(_iMageUrl),), right: FirebaseAuth.instance.currentUser!.uid == _userUid ? 90 : null, top: 0, left: FirebaseAuth.instance.currentUser!.uid != _userUid ? 90 : null,)
        ],
        );
      }
      return Container();
    },
    future: getUserNaMe());
  }
}