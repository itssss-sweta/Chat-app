import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageUploadService {
  static Future<String?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
      onFileLoading: (value) {
        return const CircularProgressIndicator();
      },
    );
    if (result != null) {
      log(result.files.first.toString());
    } else {
      log('File picking canceled by user.');
    }

    log(result?.files.first.toString() ?? '');
    File imageFile = File(result?.files.first.path ?? '');
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    var ref =
        FirebaseStorage.instance.ref().child('profile_pictures/$imageName.jpg');
    //check if user selected an image
    if (imageFile.existsSync())
    // Upload the image to Firebase Storage
    {
      await ref.putFile(imageFile);

      // Get the download URL
      String downloadURL = await ref.getDownloadURL();
      log(downloadURL);
      return downloadURL;
    } else {
      log('Selected file not found');
      return '';
    }
  }
}
