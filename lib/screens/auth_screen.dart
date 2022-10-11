import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chatapp/helpers/datafetcherandparser.dart';
import 'package:firebase_chatapp/screens/auth_forM.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget{
  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}
class _AuthScreenState extends State<AuthScreen>{
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<bool> _subMit(String eMail, String password, String userNaMe, bool isLogin, File? iMage) async{
    try {
      final UserCredential userCredential;
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: eMail, password: password);
        print("eMail : ${userCredential.user!.email}");
        print("uid : ${userCredential.user!.uid}");
        String userNaMe = await DataFetcherAndParser.getUserNaMe(userCredential.user!.uid);
        print("loguser: $userNaMe");
      }
      else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: eMail, password: password);
        final ref = FirebaseStorage.instance.ref().child("iMages/").child(userCredential.user!.uid + ".jpg");
        final refOne = await ref.putFile(iMage!).whenComplete((){
          print("IMage uploading coMpleted");
        });
        String iMageUrl = await refOne.ref.getDownloadURL();
        FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).set({
          "email" : eMail,
          "username" : userNaMe,
          "iMageUrl" : iMageUrl
        });
        print("download iMageurl : $iMageUrl");
      }
    }
    on FirebaseAuthException catch(err){
      var Message = "Please check your credientials";
      if(err.message != null){
        Message = err.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
        Message
      )));
    }
    catch(err){
      print(err.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
          err.toString()
      )));
    }
    finally{
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      body: AuthForM(subMitFn: _subMit,),

    );
  }
}