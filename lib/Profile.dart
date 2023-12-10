import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:projetinteg3eme/services/authentification_firbase_service.dart';
import 'loginPassager.dart' as loginPassager;


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gérer Profile'),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 55.0),
              child:IconButton(
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
        body: GererProfilePage(),
      ),
    );
  }
}

class GererProfilePage extends StatefulWidget {

  @override
  _GererProfilePageState createState() => _GererProfilePageState();
}

class _GererProfilePageState extends State<GererProfilePage> {

  final FirebaseAuthService _auth =FirebaseAuthService();

  late Stream<DocumentSnapshot<Map<String, dynamic>>> userStream;
  String _uid = "Vsx1v8RAqWR9BehDTMugFdfxQtJ2";


  getUser() async{
    String utilisateurUID = await _auth.userInfos();
    if(utilisateurUID != "null"){
      print("test init : "+utilisateurUID);
      _uid = utilisateurUID;
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
    userStream = FirebaseFirestore.instance.collection('users').doc(_uid).snapshots();
  }

  Future<void> _showUpdateDialog(Map<String, dynamic>? userData,BuildContext context) async {

    final TextEditingController _nomController = TextEditingController(text: userData?['nom']);
    final TextEditingController _prenomController = TextEditingController(text: userData?['prenom']);
    final TextEditingController _localisationController = TextEditingController(text: userData?['localisation']);
    final TextEditingController _genreController = TextEditingController(text: userData?['genre']);
    final TextEditingController _datedenaissanceController = TextEditingController(text: userData?['datedenaissance']);
    final TextEditingController _telephoneController = TextEditingController(text: userData?['telephone']);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier Mes Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: _nomController,
                  decoration: InputDecoration(labelText: 'Nom'),
                ),
                TextFormField(
                  controller: _prenomController,
                  decoration: InputDecoration(labelText: 'Prénom'),
                ),
                TextFormField(
                  controller: _localisationController,
                  decoration: InputDecoration(labelText: 'localisation'),
                ),
                TextFormField(
                  controller: _genreController,
                  decoration: InputDecoration(labelText: 'genre'),
                ),
                TextFormField(
                  controller: _datedenaissanceController,
                  decoration: InputDecoration(labelText: 'Date de Naissance'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context, initialDate: DateTime.now(),
                        firstDate: DateTime(1950), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime.now()
                    );

                    if(pickedDate != null ){
                      print(pickedDate);
                      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                      print(formattedDate);
                      setState(() {
                        _datedenaissanceController.text = formattedDate; //set output date to TextField value.
                      });
                    }else{
                      print("Date is not selected");
                    }
                  },
                ),
                TextFormField(
                  controller: _telephoneController,
                  decoration: InputDecoration(labelText: 'Telephone'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                 _auth.update_Info(
                    _nomController.text,
                    _prenomController.text,
                    _telephoneController.text,
                    _localisationController.text,
                    _datedenaissanceController.text,
                    _genreController.text,
                    _uid);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Profile modifié avec succée !'),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var userData = snapshot.data!.data();

          // Display the data in your UI
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),

              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Text('Demande ID: ${widget.demandeId}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 10),
                        DecoratedField(label: 'UID :', value: '${_uid}'),
                        DecoratedField(label: 'Nom :', value: '${userData?['nom']}'),
                        DecoratedField(label: 'Prenom :', value: '${userData?['prenom']}'),
                        DecoratedField(label: 'Localisation :', value: '${userData?['localisation']}'),
                        DecoratedField(label: 'Genre :', value: '${userData?['genre']}'),
                        DecoratedField(label: 'Date de Naissance :', value: '${userData?['datedenaissance']}'),
                        DecoratedField(label: 'Telephone :', value: '${userData?['telephone']}'),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Use SizedBox for margin between buttons and icons
                            IconButton(
                              onPressed: () {
                                _showUpdateDialog(userData,context);
                                print('Modifier');
                              },
                              icon: Icon(Icons.admin_panel_settings),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}

class DecoratedField extends StatelessWidget {
  final String label;
  final String value;

  const DecoratedField({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: Color(0xFF3980AE))),
        Row(
          children: [
            //Icon(Icons.info, size: 16, color: Colors.blue),
            SizedBox(width: 10),
            Flexible(
              child: Text('$value'),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}


