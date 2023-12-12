import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'loginPassager.dart' as loginPassager;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDLD4gYqv310QPZgJZ1QyqgDWqEyuZwZiM",
        authDomain: "integration-00001.firebaseapp.com",
        projectId: "integration-00001",
        storageBucket: "integration-00001.appspot.com",
        messagingSenderId: "211284719098",
        appId: "1:211284719098:web:6df01d1d0aaf06e14f6043",
        measurementId: "G-6FCCG7C1SB"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wassalny',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigate directly to the login page
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => loginPassager.MyApp()),
      );
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), //loader
      ),
    );
  }
}


