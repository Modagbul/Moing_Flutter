import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/model/fix_group/fix_group_models.dart';
import 'package:moing_flutter/model/fix_group/fix_team_request_models.dart';
import 'package:moing_flutter/utils/global/api_generic.dart';
import 'package:moing_flutter/utils/global/api_response.dart';

class FixGroupDataSource {
  String apiUrl = '';
  APICall call = APICall();

  Future<FixGroup?> loadFixData(int teamId) async {
    print('FixGroupState teamId : $teamId');
    final String apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (json) => json as Map<String, dynamic>,
      );


      if (apiResponse.isSuccess == true) {
        FixGroup group = FixGroup(
            name: apiResponse.data?['name'],
            introduce: apiResponse.data?['introduction'],
            getProfileImageUrl: apiResponse.data?['profileImgUrl']);

        // checkSave();
        return group;
      } else {
        print('loadFixData is Null, error code : ${apiResponse.errorCode}');
        return null;
      }
    } catch (e) {
      print('소모임 생성 실패: $e');
    }
    return null;
  }

  // 소모임 수정 API 연동
  Future<int?> fixTeamAPI({
    required int teamId,
    required bool isNameChanged,
    required bool isIntroduceChanged,
    required bool isImageChanged,
    String? fixName,
    String? fixIntroduce,
    String? fixProfileImgUrl,
  }) async {
    try {
      final String apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId';
      FixTeam data = FixTeam(
          name: isNameChanged ? fixName : null,
          introduction: isIntroduceChanged ? fixIntroduce : null,
          profileImgUrl: isImageChanged ? fixProfileImgUrl : null);

      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'PUT',
        body: data.toJson(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess == true) {
        // 목표보드 화면으로 이동
        int fixTeamId = apiResponse.data?['teamId'];
        return fixTeamId;
      } else {
        print('fixTeamAPI 에러 발생..');
      }
    } catch (e) {
      print('소모임 수정 실패: $e');
    }
    return null;
  }
}