import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MyApp extends StatelessWidget {
  final String demandeId;


  MyApp({required this.demandeId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Traiter Demande'),
        ),
        body: TraiterDemandePage(demandeId:demandeId),
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

  @override
  void initState() {
    super.initState();
    demandeStream = FirebaseFirestore.instance.collection('Demande').doc(widget.demandeId).snapshots();
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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Demande ID : ${widget.demandeId}'),
                Text('Nom : "Nom de Passager'),
                Text('Depart : ${demandeData?['depart']}'),
                Text('Destination: ${demandeData?['destination']}'),
                Text('Nombre de Passager : ${demandeData?['nbrpersonne']}'),
                Text('Prix Proposee : ${demandeData?['prix']}'),
                Text('Commentaire : ${demandeData?['commentaire']}'),

                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle Accept logic
                        // You can use demandeData and widget.demandeId to perform actions
                        print('Accepted');
                      },
                      child: Text('Accept'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Decline logic
                        // You can use demandeData and widget.demandeId to perform actions
                        print('Declined');
                      },
                      child: Text('Decline'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Negotiate logic
                        // You can use demandeData and widget.demandeId to perform actions
                        print('Negotiate');
                      },
                      child: Text('Negotiate'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
