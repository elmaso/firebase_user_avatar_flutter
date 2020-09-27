import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/auth_widget.dart';
import 'app/auth_widget_builder.dart';
import 'services/firebase_auth_service.dart';

import 'services/image_picker_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(),
        ),
        Provider<ImagePickerService>(
          create: (_) => ImagePickerService(),
        ),
      ],
      child: AuthWidgetBuilder(builder: (context, userSanpthot) {
        return MaterialApp(
          theme: ThemeData(primarySwatch: Colors.teal),
          home: AuthWidget(userSnapshot: userSanpthot,),
        );
      }),
    );
  }
}
