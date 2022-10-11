import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chatapp/widgets/chat/Messages_bubble.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("chat").orderBy("createdAt").snapshots(),
      builder: (ctx, snapShots){
        if(snapShots.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        final chatDocs = (snapShots.data as QuerySnapshot<Map<String, dynamic>>).docs;
        return ListView.builder(itemBuilder: (ctx, ind){
          return MessageBubble(chatDocs[ind]["text"], chatDocs[ind]["uid"]);
        },
        itemCount: chatDocs.length,
        );
      },
    );
  }
}