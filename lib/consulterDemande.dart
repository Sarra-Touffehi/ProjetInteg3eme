import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projetinteg3eme/services/authentification_firbase_service.dart';
import 'package:projetinteg3eme/services/demandeService.dart';
import 'classes/demande.dart';
import 'loginPassager.dart' as loginPassager;


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gérer Profile'),
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
        body: GererProfilePage(),
      ),
    );
  }
}

class GererProfilePage extends StatefulWidget {

  @override
  _GererProfilePageState createState() => _GererProfilePageState();
}

class _GererProfilePageState extends State<GererProfilePage> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  DemandeService srv = DemandeService();

  List<Demande> lst = List.empty();

  String utilisateurUID = "";


  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  void getDemande ()async{
    var aux = await srv.getDemandes();
    setState(() {
      lst = aux;
    });
    print(lst);
  }

  void getUser()async{
    var aux = await _auth.userInfos();
    setState(() {
      utilisateurUID = aux;
    });
  }

  @override
  void initState() {
    super.initState();
    getDemande();
    getUser();
  }



  Future<void> _showUpdateDialog(Demande? demande,BuildContext context) async {

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Demande ${demande!.id}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                DecoratedField(label: 'Depart :', value: demande!.depart),
                DecoratedField(label: 'Destination :', value: demande!.destination),
                DecoratedField(label: 'Nombre de Personne :', value: demande!.nbrPersonne.toString()),
                DecoratedField(label: 'Prix :', value: demande!.prix),
                DecoratedField(label: 'Commentaire :', value: demande!.commentaire),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                srv.update_Demande(demande.id.toString(), utilisateurUID);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Demande Accepter avec succée !'),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Text('Accepter Demande'),
            ),
          ],
        );
      },
    );
  }

  void onItemClick(BuildContext context,int index) {
    print('Item $index clicked!');
    _showUpdateDialog(lst.elementAt(index), context);
  }


  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: lst.length,
      itemBuilder: (BuildContext context, int index) {
        return
        ListTile(
          title: Text("Demande Id : ${lst.elementAt(index).id!}"),
          onTap: () {
            onItemClick(context,index); // Call function when tapped
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
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
