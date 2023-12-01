import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:projetinteg3eme/services/authentification_firbase_service.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Inscrire Passager'),
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

  final FirebaseAuthService _auth =FirebaseAuthService();

  final _formkey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adresseController = TextEditingController();

  TextEditingController dateDeNaissanceController = TextEditingController();
  TextEditingController genreController = TextEditingController(text: "Male");
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    dateDeNaissanceController.text = ""; //set the initial value of text field
    super.initState();
  }

  Map userData = {};

  Future<void> ajouterPassagerToFirestore() async {

    setState(() {
      userData['nom'] = firstNameController.text;
      userData['prenom'] = lastNameController.text;
      userData['telephone'] = mobileController.text;
      userData['localisation'] = adresseController.text;
      userData['email'] = emailController.text;
      userData['datedenaissance'] = dateDeNaissanceController.text;
      userData['genre'] = genreController.text;
      userData['password'] = passwordController.text;
    });

    _auth.signUp_Passager(
        firstNameController.text,
        lastNameController.text,
        mobileController.text,
        adresseController.text,
        emailController.text,
        dateDeNaissanceController.text,
        genreController.text,
        passwordController.text
    );

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


                    Center(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Container(
                            // margin: EdgeInsets.fromLTRB(200, 20, 50, 0),
                            child:ElevatedButton(
                              onPressed: () async {
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
                  ],
                )
            ),
    ),
    ),
          ),
        )
    );
  }
}
