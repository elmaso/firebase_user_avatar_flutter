import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/firebase_auth_service.dart';
import '../services/firebase_storage_service.dart';
import '../services/firestore_service.dart';
import 'home/home_page.dart';

import 'sign_in/sign_in_page.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Validar ineficiencias
    print('AuthWidget build');
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return StreamBuilder<User>(
      stream: authService.onAuthStateChanged,
      builder: (context, snapshot) {
        print('SrteamBuilder: ${snapshot.connectionState}');
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          // Cambiamos a favor de manejar el usuario via Provider a toda el app
          if (user != null) {
            return MultiProvider(
              providers: [
                Provider<User>.value(
                  value: user,
                ),
                Provider<FirebaseStorageService>(
                  create: (_) => FirebaseStorageService(uid: user.uid),
                ),
                Provider<FirestoreService>(
                  create: (_) => FirestoreService(uid: user.uid),
                )
              ],
              child: HomePage(),
            );
          }
          return SignInPage();
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
