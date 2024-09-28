import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseconn3/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginCreatePage extends StatefulWidget {
  @override
  State<LoginCreatePage> createState() => _LoginCreatePageState();
}

class _LoginCreatePageState extends State<LoginCreatePage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    //SOLICITIO INICIO DE SESIÓN CON GOOGLE
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

    //OBTENGO LA AUTENTICACIÓN DE GOOGLE
    GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    //CREAMOS CREDENCIALES PARA EL INICIO EN FIREBASE
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    //INICIO SESIÓN EN FIREBASE CON LAS CREDENCIALES OBTENIDAS
    User? user = (await _firebaseAuth.signInWithCredential(credential)).user;
    print(user);
    return user;
  }

  Future<void> createAccount() async {
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
            email: "demostracion@gmail.com", password: "demostracion123");
  }

  Future<void> loginAccount() async {
    _firebaseAuth
        .signInWithEmailAndPassword(
            email: "demostracion@gmail.com", password: "demostracion123")
        .then((value) {
      print(value);
    });
  }

  Future<void> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = userCredential.user;
      if (user != null) {
        await AuthService.createUserInFirestore(user);

        print(user);
        // if (mounted) {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => const HomeScreen()),
        //   );
        // }
      } else {
        // _showSnackBar('Error al iniciar sesión con Google');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                createAccount();
              },
              child: Text("Crear cuenta"),
            ),
            ElevatedButton(
              onPressed: () {
                loginAccount();
              },
              child: Text("Iniciar sesión"),
            ),
            ElevatedButton(
              onPressed: () {
                signInWithGoogle();
              },
              child: Text("Iniciar con GOOGLE"),
            ),
            ElevatedButton(
              onPressed: () {
                _signInWithGoogle();
              },
              child: Text("Iniciar con GOOGLE VICTOR"),
            ),
          ],
        ),
      ),
    );
  }
}
