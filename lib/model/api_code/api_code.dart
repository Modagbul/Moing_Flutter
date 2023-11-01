import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/post/post_detail_model.dart';
import 'package:moing_flutter/model/request/create_comment_request.dart';
import 'package:moing_flutter/model/request/create_post_request.dart';
import 'package:moing_flutter/model/request/make_team_request.dart';
import 'package:moing_flutter/model/profile/profile_model.dart';
import 'package:moing_flutter/model/response/get_all_comments_response.dart';
import 'package:moing_flutter/model/response/get_all_posts_response.dart';
import 'package:moing_flutter/model/response/get_my_page_data_response.dart';
import 'package:moing_flutter/model/response/get_single_board.dart';

class ApiCode {
  final APICall call = APICall();
  String apiUrl = '';

  void makeTeamAPI() async {
    apiUrl = '${dotenv.env['MOING_API']}/api/team';

    MakeTeamData data = MakeTeamData(
      category: 'SPORTS',
      name: '현석모닥불테스트',
      introduction: '반가워요 모닥불!',
      promise: '우리 모두 화이팅입니다!',
      profileImgUrl: 'hyunseok',
    );

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'POST',
        body: data.toJson(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.data?['teamId'] != null) {
        log('소모임 생성 완료! : ${apiResponse.data?['teamId']}');
      }
    } catch (e) {
      log('소모임 생성 실패: $e');
    }
  }

  void joinTeamAPI() async {
    var teamId = 6;
    apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId';

    try {
      ApiResponse<Map<String, dynamic>>? apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'POST',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.data?['teamId'] != null) {
        log('소모임 가입 완료! : ${apiResponse.data?['teamId']}');
      }
    } catch (e) {
      log('소모임 생성 실패: $e');
    }
  }

  Future<SingleBoardData?> getSingleBoard({required int teamId}) async {
    apiUrl = '${dotenv.env['MOING_API']}/api/team/board/$teamId';

    try {
      ApiResponse<SingleBoardData>? apiResponse =
          await call.makeRequest<SingleBoardData>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) => SingleBoardData.fromJson(data),
      );

      if (apiResponse.data != null) {
        log('단일 소모임 데이터 조회 성공: ${apiResponse.data}');
        return apiResponse.data!;
      } else {
        throw Exception('ApiResponse.data is Null');
      }
    } catch (e) {
      log('단일 소모임 데이터 조회 실패: $e');
    }
    return null;
  }

  Future<MyPageData?> getMyPageData() async {
    apiUrl = '${dotenv.env['MOING_API']}/api/mypage';

    try {
      ApiResponse<MyPageData>? apiResponse = await call.makeRequest<MyPageData>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) => MyPageData.fromJson(data),
      );

      if (apiResponse.data != null) {
        log('마이페이지 데이터 조회 성공: ${apiResponse.data}');
        return apiResponse.data!;
      } else {
        throw Exception('ApiResponse.data is Null');
      }
    } catch (e) {
      log('마이페이지 데이터 조회 실패: $e');
    }
    return null;
  }

  Future<ProfileData?> getProfileData() async {
    apiUrl = '${dotenv.env['MOING_API']}/api/mypage/profile';

    try {
      ApiResponse<ProfileData>? apiResponse =
          await call.makeRequest<ProfileData>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) => ProfileData.fromJson(data),
      );

      if (apiResponse.data != null) {
        log('프로필 데이터 조회 성공: ${apiResponse.data}');
        return apiResponse.data!;
      } else {
        throw Exception('ApiResponse.data is Null');
      }
    } catch (e) {
      log('프로필 데이터 조회 실패: $e');
    }
    return null;
  }

  void putProfileData({required ProfileData profileData}) async {
    apiUrl = '${dotenv.env['MOING_API']}/api/mypage/profile';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'PUT',
        body: profileData.toJson(),
        fromJson: (data) => data as Map<String, dynamic>,
      );
      log('프로필 데이터 수정 성공: ${apiResponse.data}');
    } catch (e) {
      log('프로필 데이터 수정 실패: $e');
    }
  }

  Future<AllPostData?> getAllPostData({required int teamId}) async {
    apiUrl = '${dotenv.env['MOING_API']}/api/$teamId/board';

    try {
      ApiResponse<AllPostData>? apiResponse =
          await call.makeRequest<AllPostData>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) => AllPostData.fromJson(data),
      );

      if (apiResponse.data != null) {
        log('모든 공지, 게시글 데이터 조회 성공: ${apiResponse.data}');
        return apiResponse.data!;
      } else {
        throw Exception('ApiResponse.data is Null');
      }
    } catch (e) {
      log('모든 공지, 게시글 데이터 조회 실패: $e');
    }
    return null;
  }

  void postCreatePostOrNotice({
    required int teamId,
    required CreatePostData createPostData,
  }) async {
    apiUrl = '${dotenv.env['MOING_API']}/api/$teamId/board';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'POST',
        body: createPostData.toJson(),
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.data != null) {
        log('게시글/공지 생성 성공: ${apiResponse.data}');
      } else {
        throw Exception('ApiResponse.data is Null');
      }
    } catch (e) {
      log('게시글/공지 생성 실패: $e');
    }
    return null;
  }

  Future<PostDetailData?> getDetailPostData(
      {required int teamId, required int boardId}) async {
    apiUrl = '${dotenv.env['MOING_API']}/api/$teamId/board/$boardId';

    try {
      ApiResponse<PostDetailData> apiResponse =
          await call.makeRequest<PostDetailData>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) => PostDetailData.fromJson(data),
      );

      if (apiResponse.data != null) {
        log('게시글 상세 조회 성공: ${apiResponse.data}');
        return apiResponse.data!;
      } else {
        throw Exception('ApiResponse.data is Null');
      }
    } catch (e) {
      log('게시글 상세 조회 실패: $e');
    }
    return null;
  }

  Future<AllCommentData?> getAllCommentData({
    required int teamId,
    required int boardId,
  }) async {
    apiUrl = '${dotenv.env['MOING_API']}/api/$teamId/$boardId/comment';

    try {
      ApiResponse<AllCommentData> apiResponse =
          await call.makeRequest<AllCommentData>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) => AllCommentData.fromJson(data),
      );

      if (apiResponse.data != null) {
        log('게시글 댓글 전체 조회 성공: ${apiResponse.data}');
        return apiResponse.data!;
      } else {
        throw Exception('ApiResponse.data is Null');
      }
    } catch (e) {
      log('게시글 댓글 전체  조회 실패: $e');
    }
    return null;
  }

  void postCreateComment({
    required int teamId,
    required int boardId,
    required CreateCommentData createCommentData,
  }) async {
    apiUrl = '${dotenv.env['MOING_API']}/api/$teamId/$boardId/comment';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'POST',
        body: createCommentData.toJson(),
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.data != null) {
        log('게시글 댓글 생성 성공: ${apiResponse.data}');
      } else {
        throw Exception('ApiResponse.data is Null');
      }
    } catch (e) {
      log('게시글 댓글 생성 실패: $e');
    }
    return null;
  }

  void deleteComment({
    required int teamId,
    required int boardId,
    required int boardCommentId,
  }) async {
    apiUrl = '${dotenv.env['MOING_API']}/api/$teamId/$boardId/comment/$boardCommentId';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'DELETE',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.data != null) {
        log('게시글 댓글 삭제 성공: ${apiResponse.data}');
      } else {
        throw Exception('ApiResponse.data is Null');
      }
    } catch (e) {
      log('게시글 댓글 삭제 실패: $e');
    }
    return null;
  }

  void deletePost({
    required int teamId,
    required int boardId,
  }) async {
    apiUrl = '${dotenv.env['MOING_API']}/api/$teamId/board/$boardId';
    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'DELETE',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.data != null) {
        log('게시글 삭제 성공: ${apiResponse.message}');
      } else {
        throw Exception('ApiResponse.data is Null');
      }
    } catch (e) {
      log('게시글 삭제 실패: $e');
    }
    return null;
  }

  void putUpdatePostOrNotice({
    required int teamId,
    required int boardId,
    required CreatePostData createPostData,
  }) async {
    apiUrl = '${dotenv.env['MOING_API']}/api/$teamId/board/$boardId';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'PUT',
        body: createPostData.toJson(),
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.data != null) {
        log('게시글/공지 수정 성공: ${apiResponse.data}');
      } else {
        throw Exception('ApiResponse.data is Null');
      }
    } catch (e) {
      log('게시글/공지 수정 실패: $e');
    }
    return null;
  }

// void makeMissionAPI() async {
//   var teamId = 6;
//   apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions';
//   String? accessToken = await tokenManagement.loadAccessToken();
//
//   // 분 부터 00 으로 표기하면 됩니다.
//   MakeMissionData data = MakeMissionData(
//       title: '미션 제목 테스트1',
//       dueTo: '2023-12-31 23:00:00.000',
//       rule: '규칙 테스트입니다.',
//       content: '내용 테스트입니다.',
//       number: 2,
//       type: 'ONCE',
//       way: 'TEXT');
//
//   final response = await http.post(
//     Uri.parse(apiUrl),
//     headers: {
//       "Content-Type": "application/json;charset=UTF-8",
//       "Authorization": "Bearer $accessToken",
//     },
//     body: jsonEncode(data.toJson()),
//   );
//   Map<String, dynamic> responseBody = jsonDecode(response.body);
//   if (response.statusCode == 200) {
//     print('소모임 미션 생성 : ${utf8.decode(response.bodyBytes)}');
//     if(responseBody['isSuccess'] == true) {
//       ApiResponse<MakeMissionResponse> apiResponse = ApiResponse.fromJson(
//         jsonDecode(utf8.decode(response.bodyBytes)),
//             (data) => MakeMissionResponse.fromJson(data),
//       );
//       print('미션 생성 완료 : ${apiResponse.data.missionId}');
//       print('미션 생성 완료, 제목 & 규칙 : ${apiResponse.data.title}, ${apiResponse.data.rule}');
//     }
//   } else {
//     print(responseBody['errorCode']);
//   }
// }
//
// void getSingleMission() async {
//   var teamId = 6;
//   var missionId = 1;
//   apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId';
//   String? accessToken = await tokenManagement.loadAccessToken();
//
//   final response = await http.get(
//     Uri.parse(apiUrl),
//     headers: {
//       "Content-Type": "application/json;charset=UTF-8",
//       "Authorization": "Bearer $accessToken",
//     },
//   );
//
//   if (response.statusCode == 200) {
//     Map<String, dynamic> responseBody = jsonDecode(response.body);
//     print('소모임 미션 생성 : ${utf8.decode(response.bodyBytes)}');
//     if(responseBody['isSuccess'] == true) {
//       ApiResponse<MakeMissionResponse> apiResponse = ApiResponse.fromJson(
//         jsonDecode(utf8.decode(response.bodyBytes)),
//             (data) => MakeMissionResponse.fromJson(data),
//       );
//       print('미션 조회 완료 : ${apiResponse.data.missionId}');
//       print('미션 조회 완료, 제목 & 규칙 : ${apiResponse.data.title}, ${apiResponse.data.rule}');
//     }
//   }
//   else {
//     print('에러 : ${response.statusCode}');
//   }
// }
//
// void fixSingleMission() async {
//   var teamId = 6;
//   var missionId = 1;
//
//   apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId';
//   String? accessToken = await tokenManagement.loadAccessToken();
//
//   // 분 부터 00 으로 표기하면 됩니다.
//   MakeMissionData data = MakeMissionData(
//       title: '미션 제목 테스트 수정1',
//       dueTo: '2023-12-31 23:00:00.000',
//       rule: '규칙 테스트 수정입니다.',
//       content: '내용 테스트 수정입니다.',
//       number: 2,
//       type: 'ONCE',
//       way: 'TEXT');
//
//   final response = await http.put(
//     Uri.parse(apiUrl),
//     headers: {
//       "Content-Type": "application/json;charset=UTF-8",
//       "Authorization": "Bearer $accessToken",
//     },
//     body: jsonEncode(data.toJson()),
//   );
//
//   if (response.statusCode == 200) {
//     Map<String, dynamic> responseBody = jsonDecode(response.body);
//     print('소모임 미션 수정 : ${utf8.decode(response.bodyBytes)}');
//     if(responseBody['isSuccess'] == true) {
//       ApiResponse<MakeMissionResponse> apiResponse = ApiResponse.fromJson(
//         jsonDecode(utf8.decode(response.bodyBytes)),
//             (data) => MakeMissionResponse.fromJson(data),
//       );
//       print('미션 수정 완료 : ${apiResponse.data.missionId}');
//       print('미션 수정 완료, 제목 & 규칙 : ${apiResponse.data.title}, ${apiResponse.data.rule}');
//     }
//   }
// }
//
// void removeMission() async {
//   var teamId = 6;
//   var missionId = 1;
//
//   apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId';
//   String? accessToken = await tokenManagement.loadAccessToken();
//
//   final response = await http.delete(
//     Uri.parse(apiUrl),
//     headers: {
//       "Content-Type": "application/json;charset=UTF-8",
//       "Authorization": "Bearer $accessToken",
//     },
//   );
//
//   if (response.statusCode == 200) {
//     Map<String, dynamic> responseBody = jsonDecode(response.body);
//     print('소모임 미션 삭제 : ${utf8.decode(response.bodyBytes)}');
//     if(responseBody['isSuccess'] == true) {
//       print('소모임 미션 삭제 성공!');
//     }
//   }
// }
//
// void certifyMission() async {
//   var teamId = 6;
//   var missionId = 3;
//
//   apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive';
//   String? accessToken = await tokenManagement.loadAccessToken();
//   Map data = {"status": 'SKIP', "archive": 'text'};
//
//   final response = await http.post(
//     Uri.parse(apiUrl),
//     headers: {
//       "Content-Type": "application/json;charset=UTF-8",
//       "Authorization": "Bearer $accessToken",
//     },
//     body: json.encode(data),
//   );
//
//   Map<String, dynamic> responseBody = jsonDecode(response.body);
//   if(responseBody['isSuccess'] == true) {
//     ApiResponse<MissionArchive> apiResponse = ApiResponse.fromJson(
//       jsonDecode(utf8.decode(response.bodyBytes)),
//           (data) => MissionArchive.fromJson(data),
//     );
//     print('미션 수정 완료 : ${apiResponse.data.archiveId}');
//     print('미션 수정 완료, 제목 & 규칙 : ${apiResponse.data.archive}, ${apiResponse.data.status}');
//   }
//   else {
//     print(responseBody['errorCode']);
//   }
// }
//
// void fixTeam() async {
//
// }
}
