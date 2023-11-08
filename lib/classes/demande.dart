import 'package:dio/dio.dart';

class Demande {
  int? id;
  String depart;
  String destination;
  String prix;
  int nbrPersonne;
  String commentaire;

  Demande({
    required this.depart,
    required this.destination,
    required this.prix,
    required this.nbrPersonne,
    required this.commentaire,
  });

  Demande.withId({
    required this.id,
    required this.depart,
    required this.destination,
    required this.prix,
    required this.nbrPersonne,
    required this.commentaire,
  });

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