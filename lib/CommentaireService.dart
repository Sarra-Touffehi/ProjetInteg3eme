import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projetinteg3eme/services/authentification_firbase_service.dart' as auth;
import 'package:flutter/material.dart';
import 'package:projetinteg3eme/classes/Commentaire.dart';
class CommentService {
  final CollectionReference commentsCollection = FirebaseFirestore.instance
      .collection('Comments');
  final auth.FirebaseAuthService _auth = auth.FirebaseAuthService();

  Future<void> addComment(String text,double rating) async {
    String userId = await _auth.userInfos();

    await commentsCollection.add({
      'userId': userId,
      'text': text,
      'rating': rating,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }



  Future<List<Comment>> getComments() async {
    try {
      // Récupérer l'identifiant de l'utilisateur actuellement authentifié
      String userId = await _auth.userInfos();

      // Récupérer les commentaires de la collection Firestore
      QuerySnapshot querySnapshot = await commentsCollection.get();

      // Mapper les documents Firestore en objets Comment
      List<Comment> comments = querySnapshot.docs.map((doc) {
        return Comment.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return comments;
    } catch (e) {
      print('Erreur lors de la récupération des commentaires: $e');
      return [];
    }
  }
}