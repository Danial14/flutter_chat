import 'package:cloud_firestore/cloud_firestore.dart';

class DataFetcherAndParser{
  static Future<String> getUserNaMe(String userId) async{
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance.collection("users").doc(userId).get();
    print("userNaMe: ${data.data()!["username"]}");
    return data.data()!["username"];
  }
}