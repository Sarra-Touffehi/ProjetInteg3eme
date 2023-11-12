import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'demande_page.dart'as demande;
import 'inscri_passager_page.dart' as isnPassager;
import 'traiter_demande.dart' as traiterDemande;

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
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wassalny',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: MyHomePage(title: "Wassalny",),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void interfaceAjoutDemande() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => demande.MyApp()),
    );
  }

  void interfaceInscriptionPassager() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => isnPassager.MyApp()),
    );
  }

  void interfaceTraiterDemande() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => traiterDemande.MyApp(demandeId : "1"))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
                icon: const Icon(
                  Icons.add,
                  color: Colors.pink,
                  size: 32.0,
                ),
                label: const Text("Demander", style: TextStyle(fontSize: 18.0)),
                onPressed: () {
                  interfaceAjoutDemande();
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(12.0),
                  ),
                ),
              ),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.add,
                color: Colors.pink,
                size: 32.0,
              ),
              label: const Text("S'inscrire", style: TextStyle(fontSize: 18.0)),
              onPressed: () {
                interfaceInscriptionPassager();
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.all(12.0),
                ),
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.add,
                color: Colors.pink,
                size: 32.0,
              ),
              label: const Text("Traiter Demande", style: TextStyle(fontSize: 18.0)),
              onPressed: () {
                interfaceTraiterDemande();
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.all(12.0),
                ),
              ),
            ),
          ],
        );
  }
}
