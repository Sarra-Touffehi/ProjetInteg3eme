import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projetinteg3eme/classes/Vehicule.dart';
class VehiculeService {
  final CollectionReference vehiculesCollection =
  FirebaseFirestore.instance.collection('vehicules');

  Future<void> addVehicule(String marque, String modele, String matricule) async {
    await vehiculesCollection.add({
      'marque': marque,
      'modele': modele,
      'matricule': matricule,
    });
  }

  Future<List<Vehicule>> getVehicules() async {
    QuerySnapshot querySnapshot = await vehiculesCollection.get();

    return querySnapshot.docs.map((doc) {
      return Vehicule.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
