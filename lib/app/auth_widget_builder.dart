import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/firebase_auth_service.dart';
import '../services/firebase_storage_service.dart';
import '../services/firestore_service.dart';
import 'home/home_page.dart';

import 'sign_in/sign_in_page.dart';


/// Se usa para crear objetos user-dependant que deben 
/// ser vistio por todos los widgets
/// Este windget debe vivir arriba de [MaterialApp]
/// ver [AuthWidget], un desenciente que consume snapshot generada por el buidler
class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key key, @required this.builder}) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;

  @override
  Widget build(BuildContext context) {
    //Validar ineficiencias
    print('AuthWidgetBuilder build');
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return StreamBuilder<User>(
      stream: authService.onAuthStateChanged,
      builder: (context, snapshot) {
        print('SrteamBuilder: ${snapshot.connectionState}');

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
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}
