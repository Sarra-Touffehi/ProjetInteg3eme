import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'demande_page.dart'as demande;

void main() {
  //debugPaintSizeEnabled = true;
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
  // int _counter = 0;
  //
  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  void interfaceAjoutDemande() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => demande.MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: 150.0,
        height: 50.0,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.add,
            color: Colors.pink,
            size: 32.0, // Adjust the icon size here
          ),
          label: const Text("Ajouter", style: TextStyle(fontSize: 18.0)), // Adjust the text size here
          onPressed: () {
            interfaceAjoutDemande();
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.all(12.0), // Adjust the padding here
            ),
          ),
        )
      );
  }
}
