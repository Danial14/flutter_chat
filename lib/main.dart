import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chatapp/firebase_options.dart';
import 'package:firebase_chatapp/screens/auth_screen.dart';
import 'package:firebase_chatapp/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> backgroundNotificationHandler(RemoteMessage Message) async{
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print("Background Message : ${Message.data}");
    if(Message.notification != null){
      print("Background Message Notification : ${Message.notification!.body}");
    }
}
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging Messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onMessage.listen((Message) {
    print("Mesaage : ${Message.data}");
    if(Message.notification != null){
      print("Notification : ${Message.notification!.body}");
    }
  });
  FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(primary: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
        backgroundColor: Colors.cyanAccent,
        fontFamily: "Lobster"
      ),
      /*theme: Theme.of(context).copyWith(
        backgroundColor: Colors.red,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.black,
          textTheme: ButtonTextTheme.accent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
        )
      )*/
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, user){
        if(user.hasData){
          print("currentUser : ${FirebaseAuth.instance.currentUser!.uid}");
          return ChatScreen();
        }
        return AuthScreen();
      },
      ),
    );
  }
}
