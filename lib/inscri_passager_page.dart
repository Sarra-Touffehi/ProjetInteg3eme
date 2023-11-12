import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/foundation.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Inscrir Passager'),
        ),
        body: InsPassager(),
      ),
    );
  }
}

class InsPassager extends StatefulWidget {
  const InsPassager({Key? key}) : super(key: key);

  @override
  State<InsPassager> createState() => _InscriptionState();
}

class _InscriptionState extends State<InsPassager> {
  Map userData = {};

  final _formkey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adresseController = TextEditingController();

  Future<void> ajouterPassagerToFirestore() async {

    CollectionReference passagers = FirebaseFirestore.instance.collection('Passagers');

    QuerySnapshot toutLesPassagers = await passagers.get();
    int nombrePassagers = toutLesPassagers.docs.length;
    String idPassager = (nombrePassagers + 1).toString();
    DocumentReference docRef = passagers.doc(idPassager);

    // Set the data for the document
    await docRef.set({
      'nom': firstNameController.text,
      'prenom': lastNameController.text,
      'telephone': mobileController.text,
      'localisation': adresseController.text,
      'email': emailController.text,
    });

    setState(() {
      userData['nom'] = firstNameController.text;
      userData['prenom'] = lastNameController.text;
      userData['telephone'] = mobileController.text;
      userData['localisation'] = mobileController.text;
      userData['email'] = emailController.text;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: firstNameController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Veiller entrer votre Nom'),
                          MinLengthValidator(3,
                              errorText: 'Le Nom doit etre de 3 charactere minimum'),
                        ]),

                        decoration: InputDecoration(
                            hintText: 'Entre Votre Nom',
                            labelText: 'Nom',
                            prefixIcon: Icon(
                              Icons.person,
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
                        controller: lastNameController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Veiller entrer votre Prenom'),
                          MinLengthValidator(3,
                              errorText:
                              'Le Prenom doit etre de 3 charactere minimum'),
                        ]),
                        decoration: InputDecoration(
                            hintText: 'Entre Votre Prenom',
                            labelText: 'Preom',
                            prefixIcon: Icon(
                              Icons.person,
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
                        controller: mobileController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Entrer Numero Telephone'),
                          MinLengthValidator(8, errorText: 'Le numéro de portable doit être composé de 8 chiffres'),
                          MaxLengthValidator(8, errorText: 'Le numéro de portable doit être composé de 8 chiffres'),
                          PatternValidator(r'^[0-9]*$', errorText: 'Seuls les chiffres sont autorisés'),
                        ]),
                        decoration: InputDecoration(
                            hintText: 'Mobile',
                            labelText: 'Mobile',
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.blue,
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius:
                                BorderRadius.all(Radius.circular(9)))
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: adresseController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Veiller entrer votre Adresse'),
                          MinLengthValidator(10,
                              errorText:
                              'L Adresse doit etre de 10 charactere minimum'),
                        ]),
                        decoration: InputDecoration(
                            hintText: 'Entre Votre Adresse',
                            labelText: 'Adresse',
                            prefixIcon: Icon(
                              Icons.home,
                              color: Colors.blueGrey,
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
                        controller: emailController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Veiller entrer Votre E-mail'),
                          EmailValidator(
                              errorText: 'Entrer une Adresse valide'),
                        ]),
                        decoration: InputDecoration(
                            hintText: 'E-mail',
                            labelText: 'E-mail',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.yellow,
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
                                setState(() {
                                  userData['nom'] = firstNameController.text;
                                  userData['prenom'] = lastNameController.text;
                                  userData['telephone'] = emailController.text;
                                  userData['localisation'] = mobileController.text;
                                  userData['email'] = mobileController.text;
                                });
                                if (_formkey.currentState!.validate()) {
                                  await ajouterPassagerToFirestore();
                                  print('form submiitted');
                                  print(userData);
                                }
                              },
                              child: Text('Ajouter'),
                            ),

                            width: MediaQuery.of(context).size.width,
                            height: 50,
                          ),
                        )),
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 60),
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ));
  }
}
