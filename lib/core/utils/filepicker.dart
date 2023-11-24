import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<FilePickerResult?> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowCompression: true,
    allowedExtensions: ["jpg", "png", "jpeg"],
    allowMultiple: true,
    onFileLoading: (value) {
      return const CircularProgressIndicator();
    },
  );
  log(result?.files.first.toString() ?? '');
  return result;
  // if (result != null) {
  //   setState(() {
  //     messages.addAll(result.files);
  //   });
  //   if (messages.isNotEmpty && messages.last.path != null) {
  //     File imageFile = File(messages.last.path!);
  //     List<int> imageBytes = await imageFile.readAsBytes();

  //     // Encode the image bytes to base64
  //     String base64Image = base64Encode(imageBytes);
  //     log(base64Image);

  //     // Send the base64-encoded image data
  //     channel.sink.add(base64Image);
  //   }
  // }
}
