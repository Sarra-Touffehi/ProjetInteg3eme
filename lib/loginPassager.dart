import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projetinteg3eme/services/authentification_firbase_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth =FirebaseAuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200.0, // Ajustez la largeur selon vos besoins
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: 200.0, // Ajustez la largeur selon vos besoins
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Ajoutez ici la logique de vérification des identifiants
                _signIn();
                String email = emailController.text;
                String password = passwordController.text;

                // Affichez les identifiants pour le moment
                print('Email: $email\nPassword: $password');
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _signIn() async{
    String email=emailController.text;
    String password=passwordController.text;
    User? user=await _auth.signIn(email, password);

    if(user != null){
print("User is successfully SignedIn");
Navigator.pushNamed(context, "/main");
    }
    else{
      print("some error happend");
    }

  }
}
