import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'chauffeur.dart';
//import '../services/localisation.dart';

class Demande {
  int? id;
  String depart;
  String destination;
  String prix;
  int nbrPersonne;
  String commentaire;
  List<Chauffeur> chauffeurs= List.empty();

  Position departPosition = Position.fromMap({
    "latitude": 40.7128,
    "longitude": -74.0060,
    "accuracy": 0.0,
    "altitude": 0.0,
    "speed": 0.0,
    "speed_accuracy": 0.0,
    "heading": 0.0,
    "timestamp": DateTime.now(),
  });
  Position destinationPosition = Position.fromMap({
    "latitude": 40.7128,
    "longitude": -74.0060,
    "accuracy": 0.0,
    "altitude": 0.0,
    "speed": 0.0,
    "speed_accuracy": 0.0,
    "heading": 0.0,
    "timestamp": DateTime.now(),
  });

  Demande({
    required this.depart,
    required this.destination,
    required this.prix,
    required this.nbrPersonne,
    required this.commentaire,}){
    //chercherChauffeur();
  }

  Demande.withId({
    required this.id,
    required this.depart,
    required this.destination,
    required this.prix,
    required this.nbrPersonne,
    required this.commentaire,
  });

  // void chercherChauffeur(){
  //   //
  //   //
  //   //get al Chauffeur
  //   //baad nhotoha f variable esmou toutChauffeurs
  //   //
  //   //
  //   List<Chauffeur> toutChauffeurs=List.empty(); // nekhdhou l info ml return w nhotohom hne
  //   List<Chauffeur> chauffeursProche=List.empty();// list mtaa chwefra 9rab
  //   chauffeursProche.addAll(toutChauffeurs.where((e) {
  //     return Localisation.positionsProche(Position, e.updateupdatePosition());
  //   }))
  //   //toutChauffeurs.map((e) => if(Localisation.positionsProche(depart,e.updateupdatePosition())){chauffeursProche.});
  // }

  Future<void> ajouterDemande() async {
    final Dio dio = Dio();
    final String baseurl = "http://127.0.0.1";

    final formData = FormData.fromMap({
      "destination": destination,
      "prix": prix,
      "nbrpersonne": nbrPersonne,
      "commentaire": commentaire,
    });

    try {
      var response = await dio.post("$baseurl/apiinsererdemande.php", data: formData);

      if (response.statusCode == 200) {
        print("Demande Ajouter !");
        afficherDemande();
      } else {
        print("Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error : $e");
    }
  }

  void afficherDemande() {
    print('ID: $id');
    print('Destination: $destination');
    print('Prix: $prix');
    print('Nombre de Personnes: $nbrPersonne');
    print('Commentaire: $commentaire');
  }


}