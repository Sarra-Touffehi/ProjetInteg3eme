import 'package:dio/dio.dart';
import 'chauffeur.dart';

class Demande {
  String? id;
  String depart;
  String destination;
  String prix;
  int nbrPersonne;
  String commentaire;
  List<Chauffeur> chauffeurs= List.empty();

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

  factory Demande.fromMap(Map<String, dynamic> data, String documentId) {
    return Demande.withId(
        id: documentId,
        depart: data['depart'] ?? '',
        destination: data['destination'].toString() ?? '',
        prix: data['prix'] ?? '',
        nbrPersonne: int.parse(data['nbrpersonne']) ?? 1,
        commentaire: data['commentaire'] ?? '',);
  }


}