import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projetinteg3eme/classes/demande.dart';

class DemandeService {
  final CollectionReference demandesCollection =
  FirebaseFirestore.instance.collection('Demandes');

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Demande>> getDemandes() async {
    QuerySnapshot querySnapshot = await demandesCollection.get();

    List<Demande> demandes = querySnapshot.docs.map((doc) {
      return Demande.fromMap(doc.data() as Map<String, dynamic>,doc.id);
    }).toList();
    return demandes;

  }

  Future<void> update_Demande(String idDemande,String uid) async {
    try {
      return _firestore.collection('Demandes').doc(idDemande).update({
        'etat': uid
      });
    } catch (e) {
      print('Error: $e');
    }
  }

}
