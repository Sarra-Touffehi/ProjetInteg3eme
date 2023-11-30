import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Inscrire Chauffeur'),
        ),
        body: InsChauffeur(),
      ),
    );
  }
}

class InsChauffeur extends StatefulWidget {
  const InsChauffeur({Key? key}) : super(key: key);

  @override
  State<InsChauffeur> createState() => _InscriptionState();
}

class _InscriptionState extends State<InsChauffeur> {

  final _formkey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController NumPermisController = TextEditingController();
  TextEditingController NumMatriculeController = TextEditingController();
  TextEditingController dateDeNaissanceController = TextEditingController();
  TextEditingController genreController = TextEditingController(text: "Male");
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    dateDeNaissanceController.text = "";
    super.initState();
  }

  Map userData = {};

  Future<void> ajouterChauffeurToFirestore() async {

    CollectionReference chauffeurs = FirebaseFirestore.instance.collection('Chauffeurs');
    QuerySnapshot toutLesChauffeurs = await chauffeurs.get();
    int nombreChauffeurs = toutLesChauffeurs.docs.length;
    //crée un identifiant unique pour le nouveau passager en utilisant le nombre actuel de passagers et en l'incrémentant de 1
    String idChauffeur = (nombreChauffeurs + 1).toString();
    //crée une référence à un nouveau document dans la collection 'Passagers' avec l'identifiant nouvellement généré.
    DocumentReference docRef = chauffeurs.doc(idChauffeur);

    // Set the data for the document
    await docRef.set({
      'nom': firstNameController.text,
      'prenom': lastNameController.text,
      'telephone': mobileController.text,
      'localisation': adresseController.text,
      'email': emailController.text,
      'datedenaissance': dateDeNaissanceController.text,
      'genre': genreController.text,
      'password': passwordController.text,
      'numPermis':NumPermisController,
      'numMatricule':NumMatriculeController,
    });
//met à jour l'état de la page en assignant les valeurs actuelles
// des contrôleurs de texte aux clés correspondantes dans la carte userData.
    setState(() {
      userData['nom'] = firstNameController.text;
      userData['prenom'] = lastNameController.text;
      userData['telephone'] = mobileController.text;
      userData['localisation'] = mobileController.text;
      userData['email'] = emailController.text;
      userData['datedenaissance'] = dateDeNaissanceController.text;
      userData['genre'] = genreController.text;
      userData['numPermis'] = NumPermisController.text;
      userData['numMatricule'] = NumMatriculeController.text;

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
                      child: DropdownButtonFormField<String>(
                        value: genreController.text,
                        onChanged: (String? newValue) {
                          setState(() {
                            genreController.text = newValue!;
                          });
                        },
                        items: ['Male', 'Female'].map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          hintText: 'Genre',
                          labelText: 'Genre',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.green,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: dateDeNaissanceController,
                        decoration: InputDecoration(
                            hintText: 'Entre Votre Date de Naissance',
                            labelText: 'Date de Naissance',
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: Colors.green,
                            ),
                            errorStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius:
                                BorderRadius.all(Radius.circular(9.0)))
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context, initialDate: DateTime.now(),
                              firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101)
                          );

                          if(pickedDate != null ){
                            print(pickedDate);
                            String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                            print(formattedDate);
                            setState(() {
                              dateDeNaissanceController.text = formattedDate; //set output date to TextField value.
                            });
                          }else{
                            print("Date is not selected");
                          }
                        },
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un mot de passe';
                          }
                          // Add additional validation if needed
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Mot de Passe',
                          labelText: 'Mot de Passe',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez confirmer votre mot de passe';
                          }
                          if (value != passwordController.text) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Confirmer Mot de Passe',
                          labelText: 'Confirmer Mot de Passe',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),
                        ),
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
                        controller: NumPermisController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Veiller entrer votre Numero de Permis'),
                          MinLengthValidator(3,
                              errorText:
                              'Le numero de permis doit contenir de 3 charactere minimum'),
                        ]),
                        decoration: InputDecoration(
                            hintText: 'Entre Votre Numero de Permis',
                            labelText: 'Numéro de permis',
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
                        controller: NumMatriculeController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Veiller entrer votre matricule '),
                          MinLengthValidator(3,
                              errorText:
                              'Le numero de matricule doit contenir de 3 charactere minimum'),
                        ]),
                        decoration: InputDecoration(
                            hintText: 'Entre Votre matricule',
                            labelText: 'matricule',
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
                    Center(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Container(
                            // margin: EdgeInsets.fromLTRB(200, 20, 50, 0),
                            child:ElevatedButton(
                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  await ajouterChauffeurToFirestore();
                                  print('form submiitted');
                                  print(userData);
                                }
                                else {
                                  // Show a message if the form is not valid
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Veuillez corriger les erreurs dans le formulaire.'),
                                    ),
                                  );
                                }
                              },
                              child: Text('Ajouter'),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                          ),
                        )),
                  ],
                )
            ),
          ),
        )
    );
  }
}
