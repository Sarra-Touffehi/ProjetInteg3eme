import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class FirebaseAuthService{
FirebaseAuth _auth =FirebaseAuth.instance;
Future<User?> signIn(String email,String password) async{
  try{
    //CollectionReference<Map<String, dynamic>> passagerStream = FirebaseFirestore.instance.collection('Passager');
    UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }
  catch(e){
    print("some error occured");
  }
  return null;
}

}