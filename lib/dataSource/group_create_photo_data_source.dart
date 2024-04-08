import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GroupCreatePhotoDataSource extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();

  Future<XFile?> pickImage() async {
    try {
      final XFile? assetFile = await _imagePicker.pickImage(source: ImageSource.gallery);
      return assetFile;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }
}