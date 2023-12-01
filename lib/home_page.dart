import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'InscrireChauffeur.dart'  as InsChauffeur;
import 'demande_page.dart'as demande;
import 'inscri_passager_page.dart' as isnPassager;
import 'traiter_demande.dart' as traiterDemande;
import 'loginPassager.dart' as loginPassager;

void main() {
  runApp(MyApp());
}
//exemple de home page

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Projet Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Accueil'),
              onTap: () {
                Navigator.pop(context); // Fermer le menu
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('Mes Trajets'),
              onTap: () {

                Navigator.pop(context); // Fermer le menu
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Historique'),
              onTap: () {

                Navigator.pop(context); // Fermer le menu
              },
            ),
            //
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Bienvenue sur la page d\'accueil!',
          style: TextStyle(fontSize: 24),

        ),
      ),
    );
  }
}
