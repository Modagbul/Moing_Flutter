import 'package:image_picker/image_picker.dart';
import 'package:moing_flutter/dataSource/s3_data_source.dart';
import 'package:moing_flutter/model/s3/presigned_url_models.dart';

class S3Repository {
  final S3DataSource s3dataSource = S3DataSource();

  /// PreSignedUrl 가져오기
  Future<PreSignedUrl?> getPreSignedUrl(String fileExtension) {
    return s3dataSource.getPresignedUrl(fileExtension);
  }

  /// S3에 이미지 올리기
  Future<bool> uploadImageToS3(String preSignedUrl, XFile file, String extension) async {
    return s3dataSource.uploadImageToS3(preSignedUrl: preSignedUrl, file: file, extension: extension);
  }
}