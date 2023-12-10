import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'loginPassager.dart' as loginPassager;

class MyApp extends StatelessWidget {
  final String demandeId;

  MyApp({required this.demandeId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Traiter Demande'),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 55.0),
              child:IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  // Ajouter la logique de déconnexion ici
                  await FirebaseAuth.instance.signOut();
                  print('User logout');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => loginPassager.MyApp()),
                  );

                },
              ),
            ),
          ],
        ),
        body: TraiterDemandePage(demandeId: demandeId),
      ),
    );
  }
}

class TraiterDemandePage extends StatefulWidget {
  final String demandeId;

  const TraiterDemandePage({Key? key, required this.demandeId}) : super(key: key);

  @override
  _TraiterDemandePageState createState() => _TraiterDemandePageState();
}

class _TraiterDemandePageState extends State<TraiterDemandePage> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> demandeStream;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    demandeStream = FirebaseFirestore.instance.collection('Demandes').doc(widget.demandeId).snapshots();

   /*
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.body}');

    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App opened from notification!');
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: demandeStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var demandeData = snapshot.data!.data();

          // Display the data in your UI
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),

              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Text('Demande ID: ${widget.demandeId}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 10),
                        DecoratedField(label: 'Nom :', value: 'Nom de Passager'),
                        DecoratedField(label: 'Départ:', value: '${demandeData?['depart']}'),
                        DecoratedField(label: 'Destination:', value: '${demandeData?['destination']}'),
                        DecoratedField(label: 'Nombre des Passagers:', value: '${demandeData?['nbrpersonne']}'),
                        DecoratedField(label: 'Prix Proposé:', value: '${demandeData?['prix']}'),
                        DecoratedField(label: 'Commentaire:', value: '${demandeData?['commentaire']}'),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Use SizedBox for margin between buttons and icons
                            IconButton(
                              onPressed: () {
                                // Handle Accept logic
                                // You can use demandeData and widget.demandeId to perform actions
                                print('Accepted');
                              },
                              icon: Icon(Icons.check),
                            ),
                            SizedBox(width: 40), // Add margin between buttons
                            IconButton(
                              onPressed: () {
                                // Handle Decline logic
                                // You can use demandeData and widget.demandeId to perform actions
                                print('Declined');
                              },
                              icon: Icon(Icons.close),
                            ),
                            SizedBox(width: 40), // Add margin between buttons
                            IconButton(
                              onPressed: () {
                                // Handle Negotiate logic
                                // You can use demandeData and widget.demandeId to perform actions
                                print('Negotiate');
                              },
                              icon: Icon(Icons.chat),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}



class DecoratedField extends StatelessWidget {
  final String label;
  final String value;

  const DecoratedField({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: Color(0xFF3980AE))),
        Row(
          children: [
            //Icon(Icons.info, size: 16, color: Colors.blue),
            SizedBox(width: 10),
            Flexible(
              child: Text('$value'),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
