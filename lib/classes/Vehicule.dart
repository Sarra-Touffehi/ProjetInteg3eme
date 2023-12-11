class Vehicule {
  final String id;
  final String marque;
  final String modele;
  final String matricule;

  Vehicule({
    required this.id,
    required this.marque,
    required this.modele,
    required this.matricule,
  });

  factory Vehicule.fromMap(Map<String, dynamic> data, String documentId) {
    return Vehicule(
      id: documentId,
      marque: data['marque'] ?? '',
      modele: data['modele'] ?? '',
      matricule: data['matricule'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'marque': marque,
      'modele': modele,
      'matricule': matricule,
    };
  }
}