import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'InscrireChauffeur.dart' as InsChauffeur;
import 'demande_page.dart' as demande;
import 'inscri_passager_page.dart' as isnPassager;
import 'traiter_demande.dart' as traiterDemande;
import 'loginPassager.dart' as loginPassager;
import 'Profile.dart' as intProfile;
import 'CommentaireService.dart' as commserv;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:projetinteg3eme/classes/Commentaire.dart';
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
  final TextEditingController _commentController = TextEditingController();
  //instance de service commentaire
  final commserv.CommentService _commentService = commserv.CommentService();

  double _rating = 0.0;

  Future<void> _showCommentDialog(BuildContext context) async {
    _commentController.text = '';
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Donnez votre feedback'),

          contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
            children: [
              RatingBar.builder(
                initialRating: _rating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40.0,
                itemBuilder: (context, _) => Icon(
                  Icons.favorite,
                  color: Colors.pink,

                ),

                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
                itemPadding: EdgeInsets.only(top: 95.0),
              ),
              SizedBox(width: 25.0),
          TextField(
          controller: _commentController,
          decoration: InputDecoration(
          hintText: 'Écrivez votre commentaire ici...',
            contentPadding: EdgeInsets.only(top: 95.0),
          ),

          ),
            ],
        ),
          ),

          actions: [
          TextButton(
          onPressed: () {
          Navigator.pop(context);
          // Affichez une alerte personnalisée après la fermeture de la boîte de dialogue
          },
          child: Text('Annuler'),
          ),
          TextButton(
          onPressed: () async {
          // Ajoutez le commentaire à Firebase
          await _commentService.addComment(_commentController.text, _rating,);
          Navigator.pop(context);
          _showThankYouAlert(context);

          },
          child: Text('Ajouter'),
          ),
          ],
        );
      },
    );
  }

  void _showThankYouAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Merci pour votre feedback'),
          content: Text('À la prochaine, cher client!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
//methode pour afficher tous les commentaires

  void _showUserCommentsDialog(BuildContext context, List<Comment> userComments) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mes Commentaires'),
        content: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
        child: Column(

            children: userComments.map((comment) {
              return ListTile(
                title: Text(comment.text),
                subtitle: Text('Note: ${comment.rating.toString()}'),
              );
            }).toList(),
        ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }





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
                _showCommentDialog(context);

                //Navigator.pop(context);
              },
            ),


            ListTile(
              leading: Icon(Icons.history),
              title: Text('About-Us'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: Icon(Icons.comment),
              title: Text('My Comments'),
              onTap: () {
                // Récupérer les commentaires de l'utilisateur
                _commentService.getComments().then((userComments) {
                  // Afficher les commentaires dans une boîte de dialogue
                  _showUserCommentsDialog(context, userComments);
                });

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






