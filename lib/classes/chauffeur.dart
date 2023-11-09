import 'package:geolocator/geolocator.dart';

import '../services/localisation.dart';
import 'demande.dart';

class Chauffeur{
  int id;
  String nom;
  String positionActuelle;

  Chauffeur({
    required this.id,
    required this.nom,
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