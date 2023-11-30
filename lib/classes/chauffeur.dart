import 'package:geolocator/geolocator.dart';
import '../services/localisation.dart';
import 'demande.dart';

class Chauffeur{
  int id;
  String nom;
  String positionActuelle;
  final String prenom;
  final String adresse;
  //final int age;
  final String email;
  final int numTel;
  final String motdepasse;
  final int numPermis;
  final int numMatricule;



  Chauffeur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.email,
    required this.numTel,
    required this.motdepasse,
    required this.numMatricule,
    required this.numPermis,
    required this.positionActuelle
  }){
    updatePosition();
  }

  Future<Position> updatePosition() async {
    try {
      Localisation localisation = Localisation();
      Position currentPosition = await localisation.getCurrentLocation();
      String position = 'Latitude: ${currentPosition.latitude}, Longitude: ${currentPosition.longitude}';
      positionActuelle = position;
      return currentPosition;
    } catch (e) {
      throw "Pas d'accee";
    }
  }

  String get getPositionActuelle => positionActuelle;

  void accepterDemande(Demande demand ){

  }

  void refuserDemande(Demande demand ){

  }

  void negocierDemande(Demande demand ){

  }
}