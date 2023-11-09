import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'classes/demande.dart';
import 'package:geolocator/geolocator.dart';
import 'services/localisation.dart';


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
        ),
        body: DemandeForm(),
      ),
    );
  }
}

class DemandeForm extends StatefulWidget {
  @override
  _DemandeFormState createState() => _DemandeFormState();

}

class _DemandeFormState extends State<DemandeForm> {

  Position? currentPosition;

  int nbrPersonne = 1;

  final TextEditingController departController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController prixController = TextEditingController();
  final TextEditingController nbrpersonneController = TextEditingController(text: "1");
  final TextEditingController commentaireController = TextEditingController();


  final String baseurl="http://127.0.0.1";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm() {

    final Demande demande = Demande(
      depart: departController.text,
      destination: destinationController.text,
      prix: prixController.text,
      nbrPersonne: int.parse(nbrpersonneController.text),
      commentaire: commentaireController.text,
    );

    demande.ajouterDemande();

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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: departController,
                  decoration: InputDecoration(
                    labelText: 'Depart',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veiller enter un Depart';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  updateDestination();
                },
                child: Text('Update Localisation'),
              ),
            ],
          ),
          TextFormField(
            controller: destinationController,
            decoration: InputDecoration(
              labelText: 'Destination',
              prefixIcon: Icon(Icons.location_on),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veiller enter un Destination';
              }
              return null;
            },
          ),
          TextFormField(
            controller: prixController,
            decoration: InputDecoration(
              labelText: 'Prix',
              prefixIcon: Icon(Icons.attach_money),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veiller enter un Prix';
              }
              return null;
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: nbrpersonneController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de Personnes',
                    prefixIcon: Icon(Icons.people),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veiller enter un Nombre';
                    }else if(int.parse(value)>4){
                      return 'Le Nombre de Passager max est 4';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (nbrPersonne > 1) {
                      nbrPersonne--;
                      nbrpersonneController.text = nbrPersonne.toString();
                    }else{
                      nbrpersonneController.text = "1";
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    if (nbrPersonne < 4) {
                      nbrPersonne++;
                      nbrpersonneController.text = nbrPersonne.toString();
                    }else{
                      nbrpersonneController.text = "4";
                    }
                  });
                },
              ),
            ],
          ),
          TextFormField(
            controller: commentaireController,
            decoration: InputDecoration(
              labelText: 'Commentaire',
              prefixIcon: Icon(Icons.comment),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veiller enter un Commentaire';
              }
              return null;
            },
          ),
          SizedBox(height: 16), // Add some spacing
          Builder(
            builder: (BuildContext builderContext) {
              return ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitForm();
                  }
                },
                child: Text('Ajouter'),
              );
            },
          ),
        ],
      ),
    );
  }

}