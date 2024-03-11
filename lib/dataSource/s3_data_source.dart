import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moing_flutter/model/s3/presigned_url_models.dart';
import 'package:moing_flutter/utils/global/api_generic.dart';
import 'package:moing_flutter/utils/global/api_response.dart';
import 'package:http/http.dart' as http;

class S3DataSource {
  String apiUrl = '';
  APICall call = APICall();

  /// presigned url 발급받기
  Future<PreSignedUrl?> getPresignedUrl(String fileExtension) async {
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
        PreSignedUrl url = PreSignedUrl(
            presignedUrl: apiResponse.data?['presignedUrl'],
            imgUrl: apiResponse.data?['imgUrl']
        );

        return url;
      } else {
        print('getPresignedUrl is Null, error code : ${apiResponse.errorCode}');
        return null;
      }
    } catch (e) {
      print('presigned url 발급 실패: $e');
      return null;
    }
  }

  /// S3에 이미지 업로드
  Future<bool> uploadImageToS3({required String preSignedUrl, required XFile file, required String extension}) async {
    // 이미지 파일을 바이트로 읽기
    var imageBytes = await file.readAsBytes();

    // HTTP PUT 요청을 사용하여 S3에 업로드
    var response = await http.put(
      Uri.parse(preSignedUrl),
      headers: {
        "Content-Type": "image/$extension",
      },
      body: imageBytes,
    );

    if (response.statusCode == 200) {
      print('S3에 업로드 성공!');
      return true;
    } else {
      print('S3에 업로드 실패: ${response.statusCode}.');
      print('S3에 업로드 실패 사유2 : ${response.reasonPhrase}');
      return false;
    }
  }
}