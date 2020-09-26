import 'package:firebase_user_avatar_flutter/app/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/firebase_auth_service.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseAuthService>(
      create: (_) => FirebaseAuthService(),
          child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: SignInPage(),
      ),
    );
  }
}
