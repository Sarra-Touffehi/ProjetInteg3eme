import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'InscrireChauffeur.dart' as InsChauffeur;
import 'demande_page.dart' as demande;
import 'inscri_passager_page.dart' as isnPassager;
import 'traiter_demande.dart' as traiterDemande;
import 'loginPassager.dart' as loginPassager;
import 'Profile.dart' as intProfile;

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
 //     home: HomePage(user: ,),
    );
  }
}

class HomePage extends StatefulWidget {
  final User user;

  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        title: Text('VTC'),

        actions: [
          Padding(
            padding: EdgeInsets.only(right: 55.0),
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                // Ajouter la logique de déconnexion ici
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => intProfile.MyApp()),
                );
              },
              child: UserAccountsDrawerHeader(
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
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Accueil'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.comment),
              title: Text('FeedBacks'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('About-Us'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue sur la page d\'accueil, $userName! Tu peux ajouter votre demande',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
          /*  Image.asset(
              'assets/voiture.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ), */

          ],
        ),
      ),
      floatingActionButton:FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return DemandeContent();
            },
          );
        },
        child: Icon(Icons.add,color: Colors.white),
      ),
    );
  }
}
class DemandeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return demande.DemandeForm();
  }
}



