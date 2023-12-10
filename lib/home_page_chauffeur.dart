import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'traiter_demande.dart' as traiterDemande;
import 'loginPassager.dart' as loginPassager;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Projet Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.lightBlue[200],
      ),
      home: HomePageChauffeur(user: FirebaseAuth.instance.currentUser!),
    );
  }
}

class HomePageChauffeur extends StatefulWidget {
  final User user;

  HomePageChauffeur({required this.user});

  @override
  _HomePageChauffeurState createState() => _HomePageChauffeurState();
}

class _HomePageChauffeurState extends State<HomePageChauffeur> {
  late String userName;
  late String userEmail;

  @override
  void initState() {
    super.initState();
    userName = widget.user.displayName ?? 'user';
    userEmail = widget.user.email ?? 'user@example.com';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VTC Chauffeur'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 55.0),
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                // Logout logic
                await FirebaseAuth.instance.signOut();
                print('User logout');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => loginPassager.MyApp()),
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(userEmail),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Accueil Chauffeur'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('Mes Trajets Chauffeur'),
              onTap: () {
                Navigator.pop(context);
                // Add navigation logic for Mes Trajets Chauffeur
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('About-Us '),
              onTap: () {
                Navigator.pop(context);
                // Add navigation logic for About-Us Chauffeur
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
         child : TraiterDemandeContent(),
        ),
      ),
    );
  }
}

class TraiterDemandeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return traiterDemande.TraiterDemandePage(demandeId: "1");
  }
}
