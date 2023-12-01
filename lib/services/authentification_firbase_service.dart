import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class FirebaseAuthService{
FirebaseAuth _auth =FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<String?> userType(String email,String password) async{
  try{
    UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(credential.user!.uid)
        .get();

    if (userSnapshot.exists) {
      dynamic type = userSnapshot.get('type');
      print('Type Utilisateur : $type');
      return type;
    }
  }
  catch(e){
    print("User not found in Firestore.");
  }
  return null;
}

Future<User?> signIn(String email,String password) async{
  try{
    UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }
  catch(e){
    print("some error occured");
  }
  return null;
}

Future<User?> signUp_Passager(String nom,String prenom,String telephone,String localisation,
String email,String datedenaissance,String genre,String password) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Additional information to be saved in Firestore
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'localisation': localisation,
      'datedenaissance': datedenaissance,
      'genre': genre,
      'type': "Passager"
    });
    return userCredential.user;
  } catch (e) {
    print('Error: $e');
  }
  return null;
}

Future<User?> signUp_Chauffeur(String nom,String prenom,String telephone,String localisation,
    String email,String datedenaissance,String genre,String password,String numPermis,String numMatricule) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Additional information to be saved in Firestore
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'localisation': localisation,
      'datedenaissance': datedenaissance,
      'genre': genre,
      'numMatricule': numMatricule,
      'numPermis':numPermis,
      'type': "Chauffeur"
    });
    return userCredential.user;
  } catch (e) {
    print('Error: $e');
  }
  return null;
}



}