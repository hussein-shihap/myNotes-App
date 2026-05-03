import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/firebase_options.dart';
import 'screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
void main() async{
  WidgetsFlutterBinding.ensureInitialized(); 
    await Firebase.initializeApp( 
     options: DefaultFirebaseOptions.currentPlatform, 
);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}