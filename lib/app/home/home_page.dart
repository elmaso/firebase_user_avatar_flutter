import 'dart:async';

import 'package:firebase_user_avatar_flutter/app/home/about_page.dart';
import 'package:firebase_user_avatar_flutter/common_widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/avatar_reference.dart';

import '../../services/firebase_auth_service.dart';

import '../../services/firebase_storage_service.dart';
import '../../services/firestore_service.dart';
import '../../services/image_picker_service.dart';


class HomePage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = context.read<
          FirebaseAuthService>(); // Provider.of<FirebaseAuthService>(context);
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onAbout(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AboutPage(),
      ),
    );
  }

  Future<void> _chooseAvatar(BuildContext context) async {
    try {
      // 1. Get image from picker
      final imagePiker = context.read<ImagePickerService>();
      // Provider.of<ImagePickerService>(context, listen: false);
      final file = await imagePiker.pickImage(source: ImageSource.camera);
      if (file != null) {
        // 2. Upload to storage
        final storege = context.read<FirebaseStorageService>();
        final downloadUrl = await storege.uploadAvatar(file: file);
        // 3. Save url to Firestore
        final database = context.read<FirestoreService>();
        await database.setAvatarReference(
            avatarReference: AvatarReference(downloadUrl));
        // 4. (optional) delete local file as no longer needed
        await file.delete();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        leading: IconButton(
          icon: Icon(Icons.help),
          onPressed: () => _onAbout(context),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _signOut(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130.0),
          child: Column(
            children: <Widget>[
              _buildUserInfo(context: context),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo({BuildContext context}) {
    final database = context.watch<FirestoreService>();
    return StreamBuilder<AvatarReference>(
        stream: database.avatarReferenceStream(),
        builder: (context, snapshot) {
          final avatarReference = snapshot.data;
          return Avatar(
            photoUrl: avatarReference
                ?.downloadUrl, //Si viene nulo ponemos la camarita
            radius: 50,
            borderColor: Colors.black54,
            borderWidth: 2.0,
            onPressed: () => _chooseAvatar(context),
          );
        });
  }
}
