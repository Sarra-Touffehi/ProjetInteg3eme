import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projetinteg3eme/services/authentification_firbase_service.dart';
import 'InscrireChauffeur.dart' as InsChauffeur;
import 'inscri_passager_page.dart' as isnPassager;
import 'home_page.dart' as homePassager;
import 'home_page_chauffeur.dart' as homeChauffeur;

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
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            color: Colors.white,
            shadowColor: Colors.blue.withOpacity(0.9),
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: 350.0,
              height: 500,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: 200,
                        height: 150,
                        child: Image.asset('assets/img.png'),
                      ),
                      SizedBox(height: 16.0),
                      SizedBox(
                        width: 200.0,
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            // prefixIcon: Icon(Icons.email),
                          ),
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: _formKey.currentState?.validate() == true
                                ? Colors.black
                                : Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      SizedBox(
                        width: 200.0,
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: !showPassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            //prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                          ),
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: _formKey.currentState?.validate() == true
                                ? Colors.black
                                : Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            _signIn();
                            String email = emailController.text;
                            String password = passwordController.text;
                            print('Email: $email\nPassword: $password');
                          }
                        },
                        child: Text('Login'),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => InsChauffeur.InsChauffeur()),
                              );
                            },
                            child: Text('Sign Up as Driver'),
                          ),
                          SizedBox(width: 16.0),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => isnPassager.InsPassager()),
                              );
                            },
                            child: Text('Sign Up as Passenger'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

/*  void _signIn() async{
    String email=emailController.text;
    String password=passwordController.text;
    User? user=await _auth.signIn(email, password);

    if(user != null){
      print("User is successfully SignedIn");
      print("User UID : ${user.uid}");
      print(_auth.userType(email, password));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
    else{
      print("some error happened");
    }
  }*/

  /*
  void _signIn() async {
    String email = emailController.text;
    String password = passwordController.text;
    User? user = await _auth.signIn(email, password);

    if (user != null) {
      print("User is successfully SignedIn");
      print("User UID : ${user.uid}");

      String? userType = await _auth.userType(email, password);
      print("User Type: $userType");

      if (userType == "Chauffeur") {
        // Open TraiterDemandePage
        /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Traiterdemande.MyApp(demandeId : "1"))
        );*/

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => intProfile.MyApp())
        );

      } else if (userType == "Passager") {
        // Open DemandeForm
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => demande.MyApp()),
        );
      }
    } else {
      print("some error happened");
    }
  }
*/
  void _signIn() async {
    String email = emailController.text;
    String password = passwordController.text;
    User? user = await _auth.signIn(email, password);

    if (user != null) {
      print("User is successfully SignedIn");
      print("User UID : ${user.uid}");

      String? userType = await _auth.userType(email, password);
      print("User Type: $userType");

      if (userType == "Chauffeur") {
        // Open TraiterDemandePage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => homeChauffeur.HomePageChauffeur(user: user)),
        );
      } else if (userType == "Passager") {
        // Pass the 'user' parameter to the home page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => homePassager.HomePage(user: user)),
        );
      } else {
        print("Unknown user type");
      }
    } else {
      print("Login failed");
      // Handle login failure (show an error message, etc.)
    }
  }
}
