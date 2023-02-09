import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  XFile? _file = await ImagePicker().pickImage(source: source);
  if (_file != null) {
    return _file.readAsBytes();
  }
  print('no image selected');
}

ShowSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content)),
  );
}
