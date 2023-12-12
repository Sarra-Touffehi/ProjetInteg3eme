import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'services/localisation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginPassager.dart' as loginPassager;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ajouter Demande'),
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
        body: DemandeForm(),
      ),
    );
  }
}

class DemandeForm extends StatefulWidget {
  const DemandeForm({Key? key})  : super(key: key);

  @override
  _DemandeFormState createState() => _DemandeFormState();

}

class _DemandeFormState extends State<DemandeForm> {
 /* final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; */

  @override
  void initState() {
    super.initState();
    updateDestination();
  /*  _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');

    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.body}');

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      print('App opened from notification!');
    }); */
  }

  String? nombrePersonne="1";
  List<String> nombrePersonneOptions = ['1', '2', '3', '4'];

  final _formkey = GlobalKey<FormState>();
  Map demandeData = {};

  int nbrPersonne = 1;

  final TextEditingController departController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController prixController = TextEditingController();
  final TextEditingController nbrpersonneController = TextEditingController(text: "1");
  final TextEditingController commentaireController = TextEditingController();

  Future<void> ajouterDemandeToFirestore() async {

    CollectionReference demandes = FirebaseFirestore.instance.collection('Demandes');

    QuerySnapshot toutLesDemandes = await demandes.get();
    int nombreDemande = toutLesDemandes.docs.length;
    String idPassager = (nombreDemande + 1).toString();
    DocumentReference docRef = demandes.doc(idPassager);

    // Set the data for the document
    await docRef.set({
      'depart': departController.text,
      'destination': destinationController.text,
      'nbrpersonne': nbrpersonneController.text,
      'commentaire': commentaireController.text,
      'prix': prixController.text,
      'etat': "enattente",
    });

    setState(() {
      demandeData['depart'] = departController.text;
      demandeData['destination'] = destinationController.text;
      demandeData['nbrpersonne'] = nbrpersonneController.text;
      demandeData['commentaire'] = commentaireController.text;
      demandeData['prix'] = prixController.text;
      demandeData['etat'] = "enattente";
    });
  }

  Future<void> updateDestination() async {
    try {
      Localisation localisation = Localisation();
      Position currentPosition = await localisation.getCurrentLocation();
      String destination = 'Latitude: ${currentPosition.latitude}, Longitude: ${currentPosition.longitude}';
      departController.text = destination;
    } catch (e) {
      print('Error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
    child: Card(
    elevation: 8.0,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0),
    ),
    shadowColor: Colors.blue.withOpacity(0.9),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: Container(
                          width: 200,
                          height: 150,
                          child: Image.asset('assets/img.png'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: departController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Veiller entrer votre Adresse'),
                          MinLengthValidator(10,
                              errorText:
                              'Le Adresse doit etre de 10 charactere minimum'),
                        ]),
                        decoration: InputDecoration(
                            hintText: 'Entre Votre Depart',
                            labelText: 'Depart',
                            prefixIcon: Icon(
                              Icons.home,
                              color: Colors.green,
                            ),
                            errorStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius:
                                BorderRadius.all(Radius.circular(9.0)))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: destinationController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Veiller entrer votre Adresse'),
                          MinLengthValidator(10,
                              errorText:
                              'Le Adresse doit etre de 10 charactere minimum'),
                        ]),
                        decoration: InputDecoration(
                            hintText: 'Entre Votre Destination',
                            labelText: 'Destination',
                            prefixIcon: Icon(
                              Icons.home,
                              color: Colors.green,
                            ),
                            errorStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius:
                                BorderRadius.all(Radius.circular(9.0)))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: prixController,
                        validator:  (value) {
                              if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un prix';
                              }

                              // Use a regular expression to check for a valid decimal number
                              RegExp decimalRegex = RegExp(r'^\d+(\.\d+)?$');

                              if (!decimalRegex.hasMatch(value)) {
                              return 'Veuillez entrer un Prix valide';
                              }

                              return null;
                    },
                        decoration: InputDecoration(
                            hintText: 'Entre Votre Prix',
                            labelText: 'Prix',
                            prefixIcon: Icon(
                              Icons.map,
                              color: Colors.blue,
                            ),
                            errorStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius:
                                BorderRadius.all(Radius.circular(9.0)))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: nombrePersonne,
                        onChanged: (String? Value) {
                          setState(() {
                            nombrePersonne = Value;
                          });
                          nbrpersonneController.text = (Value) as String;
                        },
                        items: nombrePersonneOptions.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          hintText: 'Sélectionnez un nombre',
                          labelText: 'Nombre de Personne',
                          prefixIcon: Icon(
                            Icons.people,
                            color: Colors.green,
                          ),
                          errorStyle: TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.all(Radius.circular(9.0)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez sélectionner un nombre';
                          }
                          return null; // Validation passed
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: commentaireController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Veiller entrer Un Commentaire'),
                          MinLengthValidator(10,
                              errorText:
                              'Le Commentaire doit etre de 10 charactere minimum'),
                        ]),
                        decoration: InputDecoration(
                            hintText: 'Entre un Commentaire',
                            labelText: 'Commentaire',
                            prefixIcon: Icon(
                              Icons.comment,
                              color: Colors.green,
                            ),
                            errorStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius:
                                BorderRadius.all(Radius.circular(9.0)))),
                      ),
                    ),
                    Center(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Container(
                            // margin: EdgeInsets.fromLTRB(200, 20, 50, 0),
                            child:ElevatedButton(
                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  await ajouterDemandeToFirestore();
                                  print('form submiitted');
                                  print(demandeData);
                                }
                              },
                              child: Text('Ajouter'),
                            ),

                            width: MediaQuery.of(context).size.width,
                            height: 50,
                          ),
                        )),
                  ],
                )),
    ),
    ),
          ),
        ));
  }

}