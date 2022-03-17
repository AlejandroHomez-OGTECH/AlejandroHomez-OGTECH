import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthClass  extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _iniciogoogle = false;
  bool _isLoading = false;

  String nombreUsuario = '';
  String emailUsuario = '';
  String urlImageUsuario = '';

  final googleSingIn = GoogleSignIn();



  bool get inicioGoogle => _iniciogoogle;
  set setInicioGoogle(bool valor) {
    _iniciogoogle = valor;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //Reset Password
  Future<String> resetPassword({String? email}) async {
    try {
      await auth.sendPasswordResetEmail(
        email: email!,
      );
      return "Email enviado";
    } catch (e) {
      return "Se produjo un error";
    }
  }

  // Create Account
  
  Future<String?> createAccount(String email, String password,String name) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      validarCorreo(name, email, "");

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'La contraseña es demasiado debil.';
      } else if (e.code == 'email-already-in-use') {
        return 'La contraseña ya existe para este correo';
      }
    } catch (e) {
      return "Se produjo un error";
    }
  }

  //Sign in user
  Future<String?> signIN(String email, String password,) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      validarCorreo("", email, "");
      notifyListeners();
      return "" ;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Usuario no encontrado';
      } else if (e.code == 'wrong-password') {
        return 'Contraseña incorrecta.';
      }
    }
  }

  //Google Auth
  Future<UserCredential> signWithGoogle() async {
    
    setIsLoading =  true;
    notifyListeners();

    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: <String>["email"]).signIn();

    
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    validarCorreo(googleUser.displayName, googleUser.email, googleUser.photoUrl);

    setIsLoading = false;
    notifyListeners();

     return await FirebaseAuth.instance.signInWithCredential(credential);
  }

//Facebook
Future<UserCredential>signConFacebook(BuildContext context) async {
   setIsLoading = true;
    notifyListeners();

    final LoginResult loginResult =  await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
    final userData = await FacebookAuth.instance.getUserData();

    validarCorreo(userData['name'], userData['email'], userData['picture']['data']['url']);

    setIsLoading = false;
    notifyListeners();   
     return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

     
  
  }


  Future<void> signOutGmail() async {
      googleSingIn.disconnect();
         auth.signOut();
         await FacebookAuth.instance.logOut();
    }

  Future<void> signOutFb() async {
    auth.signOut();
    await FacebookAuth.instance.logOut();
    FacebookAuthProvider.credential("");
  }

  void validarCorreo(String? name, String? email, String? imageUrl) {

    int dato = 0;
     FirebaseFirestore.instance
        .collection('users')
        .orderBy('email')
        .get()
        .then((QuerySnapshot querySnapshot)  {
        for (var i = 0; i < querySnapshot.docs.length; i++) {
            if (querySnapshot.docs[i]['email'] != email) {
             dato++;
            } 
        }
          if (dato == querySnapshot.docs.length) {
            FirebaseFirestore.instance.collection('users').add({
              'email': email,
              'name': name,
              'imageUrl': imageUrl,
            });
          }
        });
  }

}

 // } on FirebaseAuthException catch (e) {
    //   String contenido = '';
    //   switch (e.code) {
    //     case 'account-exists-with-different-credential':
    //       contenido = 'Esta cuenta ya existe con una credencial diferente';
    //       break;

    //     case 'invalid-credential':
    //       contenido = 'Se producto un error por 2 correo iguales';
    //       break;

    //     case 'operation-not-allowed':
    //       contenido = 'Esta operacion no esta permitida';
    //       break;

    //     case 'user-disabled':
    //       contenido = 'Este usuraio esta deshabilidato';
    //       break;

    //     case 'user-not-found':
    //       contenido =
    //           'La usuario a la que intentaste iniciar sesión no fue encontrado';
    //       break;
    //   }

    //   // return showDialog(
    //   //     context: context,
    //   //     builder: (context) => AlertDialog(
    //   //             title: const Text('Iniciar sesión con facebook falló'),
    //   //             content: Text(contenido),
    //   //             actions: [
    //   //               TextButton(
    //   //                   onPressed: () => Navigator.of(context).pop(),
    //   //                   child: const Text('Aceptar'))
    //   //             ]));
    
  





//Facebook Simple
// Future<UserCredential> signInWithFacebook() async {
//   final LoginResult result = await FacebookAuth.instance.login();
//   final OAuthCredential facebookAuthCredential =
//       FacebookAuthProvider.credential(result.accessToken!.token);
//   return await FirebaseAuth.instance
//       .signInWithCredential(facebookAuthCredential);
// }
