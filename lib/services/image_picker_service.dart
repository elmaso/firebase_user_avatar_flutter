import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  //Returns a [File] object pointing to the image that was picked.
  // Future<File> pickImage({@required ImageSource source}) async {
  //  return  ImagePicker.pickImage(source: source);
  // }
  Future<dynamic> getImage() async {
    final picketdImage =
        await ImagePicker().getImage(source: ImageSource.camera);
    return picketdImage; //.path;
  }
}
