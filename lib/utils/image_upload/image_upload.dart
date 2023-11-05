import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:http/http.dart' as http;

class ImageUpload {
  final APICall call = APICall();

  // 파일 확장자 가져오기
  String getFileExtension(XFile file) {
    String extension = file.path.split(".").last;
    String fileExtension = '';
    if (extension == 'jpg') {
      fileExtension = 'JPG';
    } else if (extension == 'jpeg') {
      fileExtension = 'JPEG';
    } else if (extension == 'png') {
      fileExtension = 'PNG';
    }
    return fileExtension;
  }

  /// PresignedURL 발급받기
  Future<String?> getPresignedUrl(String fileExtension, XFile avatarFile) async {
    try {
      final String apiUrl = '${dotenv.env['MOING_API']}/api/image/presigned';
      Map<String, dynamic> data = {
        'imageFileExtension': fileExtension,
      };

      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'POST',
        body: data,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess == true) {
        print(apiResponse.data?.toString());
        String presignedUrl = apiResponse.data?['presignedUrl'];
        String putProfileImageUrl = apiResponse.data?['imgUrl'];

        await uploadImageToS3(presignedUrl, avatarFile, fileExtension);
        return putProfileImageUrl;
      } else {
        if (apiResponse.errorCode == 'J0003') {
          getPresignedUrl(fileExtension, avatarFile);
        }
        return null;
      }
    } catch (e) {
      print('소모임 생성 실패: $e');
      return null;
    }
  }

  // S3에 이미지 업로드
  Future<void> uploadImageToS3(String presignedUrl, XFile file, String extension) async {
    // 이미지 파일을 바이트로 읽기
    var imageBytes = await file.readAsBytes();

    // HTTP PUT 요청을 사용하여 S3에 업로드
    var response = await http.put(
      Uri.parse(presignedUrl),
      headers: {
        "Content-Type": "image/$extension",
      },
      body: imageBytes,
    );

    if (response.statusCode == 200) {
      print('S3에 업로드 성공!');
    } else {
      print('S3에 업로드 실패: ${response.statusCode}.');
      print('S3에 업로드 실패 사유 : ${response.reasonPhrase}');
    }
  }
}