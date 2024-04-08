import 'package:image_picker/image_picker.dart';

import '../dataSource/group_create_photo_data_source.dart';


class GroupCreatePhotoRepository {
  final GroupCreatePhotoDataSource _photoSource;

  GroupCreatePhotoRepository(this._photoSource);

  Future<XFile?> pickImage() async {
    return _photoSource.pickImage();
  }
}