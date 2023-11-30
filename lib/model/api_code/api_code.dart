import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/post/post_detail_model.dart';
import 'package:moing_flutter/model/request/create_comment_request.dart';
import 'package:moing_flutter/model/request/create_post_request.dart';
import 'package:moing_flutter/model/profile/profile_model.dart';
import 'package:moing_flutter/model/response/get_all_comments_response.dart';
import 'package:moing_flutter/model/response/get_all_posts_response.dart';
import 'package:moing_flutter/model/response/get_my_page_data_response.dart';
import 'package:moing_flutter/model/response/get_single_board.dart';
import 'package:moing_flutter/model/response/get_team_mission_photo_list_response.dart';
import 'package:moing_flutter/model/team/team_fire_level_models.dart';

import '../response/aggregate_repeat_mission_response.dart';
import '../response/aggregate_single_mission_response.dart';
import '../response/aggregate_team_repeat_mission_response.dart';
import '../response/aggregate_team_single_mission_response.dart';
import '../response/alarm_settings_editor_response.dart';
import '../response/alarm_settings_response.dart';
import '../response/board_completed_mission_response.dart';
import '../response/board_repeat_mission_response.dart';
import '../response/board_single_mission_response.dart';
import '../response/team_list_response.dart';

class ApiCode {
  final APICall call = APICall();
  String apiUrl = '';

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
        if (apiResponse.errorCode == 'J0003') {
          getSingleBoard(teamId: teamId);
        } else {
          throw Exception(
              'getSingleBoard data is Null, error code : ${apiResponse.errorCode}');
        }
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
        if (apiResponse.errorCode == 'J0003') {
          getMyPageData();
        } else {
          throw Exception(
              'getMyPageData is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('마이페이지 데이터 조회 실패: $e');
    }
    return null;
  }

  /// J0003 적용 ver
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
        if (apiResponse.errorCode == 'J0003') {
          getProfileData();
        } else {
          throw Exception(
              'ApiResponse.data is Null, error code : ${apiResponse.errorCode}');
        }
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

      if (apiResponse.data != null) {
        log('프로필 데이터 수정 성공: ${apiResponse.data}');
      } else {
        if (apiResponse.errorCode == 'J0003') {
          putProfileData(profileData: profileData);
        } else {
          throw Exception(
              'putProfileData is Null, error code : ${apiResponse.errorCode}');
        }
      }
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
        if (apiResponse.errorCode == 'J0003') {
          getAllPostData(teamId: teamId);
        } else {
          throw Exception(
              'getAllPostData is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('모든 공지, 게시글 데이터 조회 실패: $e');
    }
    return null;
  }

  Future<RepeatMissionStatusResponse?> getRepeatMissionStatus(
      {required int teamId}) async {
    apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/board/repeat';

    try {
      ApiResponse<List<RepeatMission>>? apiResponse =
          await call.makeRequest<List<RepeatMission>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) {
          log('반복 미션 Server response: $data');
          return (data as List<dynamic>)
              .map((item) =>
                  RepeatMission.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );

      if (apiResponse.data != null) {
        log('반복 미션 상태 조회 성공: ${apiResponse.data}');
        return RepeatMissionStatusResponse(
            isSuccess: true, message: '성공', data: apiResponse.data!);
      } else {
        if (apiResponse.errorCode == 'J0003') {
          getRepeatMissionStatus(teamId: teamId);
        } else {
          throw Exception(
              'getRepeatMissionStatus is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('반복 미션 상태 조회 실패: $e');
    }
    return null;
  }

  Future<void> postCreatePostOrNotice({
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
        if (apiResponse.errorCode == 'J0003') {
          postCreatePostOrNotice(
              teamId: teamId, createPostData: createPostData);
        } else {
          throw Exception(
              'postCreatePostOrNotice is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('게시글/공지 생성 실패: $e');
    }
    return;
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
        if (apiResponse.errorCode == 'J0003') {
          getDetailPostData(teamId: teamId, boardId: boardId);
        } else {
          throw Exception(
              'getDetailPostData is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('게시글 상세 조회 실패: $e');
    }
    return null;
  }

  Future<BoardSingleMissionResponse?> getSingleMissionStatus({
    required int teamId,
  }) async {
    String apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/board/single';

    try {
      ApiResponse<List<Mission>>? apiResponse =
          await call.makeRequest<List<Mission>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) {
          log('한번 미션 Server response: $data');
          return (data as List<dynamic>)
              .map((item) => Mission.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );

      if (apiResponse.data != null) {
        log('한번 미션 상태 조회 성공: ${apiResponse.data}');
        return BoardSingleMissionResponse(
            isSuccess: true, message: '성공', data: apiResponse.data!);
      } else {
        if (apiResponse.errorCode == 'J0003') {
          getSingleMissionStatus(teamId: teamId);
        } else {
          throw Exception(
              'getSingleMissionStatus is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('한번 미션 상태 조회 실패: $e');
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
        if (apiResponse.errorCode == 'J0003') {
          getAllCommentData(teamId: teamId, boardId: boardId);
        } else {
          throw Exception(
              'getAllCommentData is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('게시글 댓글 전체 조회 실패: $e');
    }
    return null;
  }

  Future<BoardCompletedMissionResponse?> getCompletedMissionStatus({
    required int teamId,
  }) async {
    String apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/board/finish';

    try {
      ApiResponse<List<EndedMission>>? apiResponse =
          await call.makeRequest<List<EndedMission>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) {
          log('종료된 미션 Server response: $data');
          return (data as List<dynamic>)
              .map(
                  (item) => EndedMission.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );

      if (apiResponse.data != null) {
        log('완료된 미션 상태 조회 성공: ${apiResponse.data}');
        return BoardCompletedMissionResponse(
            isSuccess: true, message: '성공', data: apiResponse.data!);
      } else {
        if (apiResponse.errorCode == 'J0003') {
          getCompletedMissionStatus(teamId: teamId);
        } else {
          throw Exception(
              'getCompletedMissionStatus is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('완료된 미션 상태 조회 실패: $e');
    }
    return null;
  }

  Future<void> postCreateComment({
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
        if (apiResponse.errorCode == 'J0003') {
          postCreateComment(
              teamId: teamId,
              boardId: boardId,
              createCommentData: createCommentData);
        } else {
          throw Exception(
              'postCreateComment is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('게시글 댓글 생성 실패: $e');
    }
    return;
  }

  void deleteComment({
    required int teamId,
    required int boardId,
    required int boardCommentId,
  }) async {
    apiUrl =
        '${dotenv.env['MOING_API']}/api/$teamId/$boardId/comment/$boardCommentId';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'DELETE',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess) {
        log('게시글 댓글 삭제 성공');
      } else {
        if (apiResponse.errorCode == 'J0003') {
          deleteComment(
              teamId: teamId, boardId: boardId, boardCommentId: boardCommentId);
        } else {
          throw Exception(
              'deleteComment is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('게시글 댓글 삭제 실패: $e');
    }
    return null;
  }

  Future<void> deletePost({
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
        if (apiResponse.errorCode == 'J0003') {
          deletePost(teamId: teamId, boardId: boardId);
        } else {
          throw Exception(
              'deletePost is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('게시글 삭제 실패: $e');
    }
    return;
  }

  Future<void> putUpdatePostOrNotice({
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
        if (apiResponse.errorCode == 'J0003') {
          putUpdatePostOrNotice(
              teamId: teamId, boardId: boardId, createPostData: createPostData);
        } else {
          throw Exception(
              'putUpdatePostOrNotice is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('게시글/공지 수정 실패: $e');
    }
    return;
  }

  Future<bool?> signOut() async {
    String apiUrl = '${dotenv.env['MOING_API']}/api/mypage/signOut';
    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'POST',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess) {
        log('로그아웃 성공!');
        return true;
      } else {
        if (apiResponse?.errorCode == 'J0003') {
          return false;
        } else {
          throw Exception(
              'signOut is Null, error code : ${apiResponse?.errorCode}');
        }
      }
    } catch (e) {
      log('로그아웃 실패: $e');
      return false;
    }
  }

  Future<AggregateSingleMissionResponse?>
      getAggregateSingleMissionStatus() async {
    String apiUrl = '${dotenv.env['MOING_API']}/api/team/my-once';

    try {
      ApiResponse<List<AggregateMission>>? apiResponse =
          await call.makeRequest<List<AggregateMission>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) {
          log('한번 미션 Server response: $data');
          return (data as List<dynamic>)
              .map((item) =>
                  AggregateMission.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );

      if (apiResponse.data != null) {
        log('한번 미션 상태 조회 성공: ${apiResponse.data}');
        return AggregateSingleMissionResponse(
            isSuccess: true, message: '성공', data: apiResponse.data!);
      } else {
        if (apiResponse.errorCode == 'J0003') {
          getAggregateSingleMissionStatus();
        } else {
          throw Exception(
              'getAggregateSingleMissionStatus is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('한번 미션 상태 조회 실패: $e');
    }
    return null;
  }

  Future<AggregateTeamSingleMissionResponse?>
      getAggregateTeamSingleMissionStatus({
    required int teamId,
  }) async {
    String apiUrl = '${dotenv.env['MOING_API']}/api/team/team-once/$teamId';

    try {
      ApiResponse<List<AggregateTeamMission>>? apiResponse =
          await call.makeRequest<List<AggregateTeamMission>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) {
          log('팀별 한번 미션 Server response: $data');
          return (data as List<dynamic>)
              .map((item) =>
                  AggregateTeamMission.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );

      if (apiResponse.data != null) {
        log('팀별 한번 미션 상태 조회 성공: ${apiResponse.data}');
        return AggregateTeamSingleMissionResponse(
            isSuccess: true, message: '성공', data: apiResponse.data!);
      } else {
        if (apiResponse.errorCode == 'J0003') {
          getAggregateTeamSingleMissionStatus(teamId: teamId);
        } else {
          throw Exception(
              'getAggregateTeamSingleMissionStatus is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('팀별 한번 미션 상태 조회 실패: $e');
    }
    return null;
  }

  Future<AggregateRepeatMissionStatusResponse?>
      getAggregateRepeatMissionStatus() async {
    apiUrl = '${dotenv.env['MOING_API']}/api/team/my-repeat';

    try {
      ApiResponse<List<AggregateRepeatMission>>? apiResponse =
          await call.makeRequest<List<AggregateRepeatMission>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) {
          log('반복 미션 Server response: $data');
          return (data as List<dynamic>)
              .map((item) =>
                  AggregateRepeatMission.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );

      if (apiResponse.data != null) {
        log('반복 미션 상태 조회 성공: ${apiResponse.data}');
        return AggregateRepeatMissionStatusResponse(
            isSuccess: true, message: '성공', data: apiResponse.data!);
      } else {
        if (apiResponse.errorCode == 'J0003') {
          getAggregateRepeatMissionStatus();
        } else {
          throw Exception(
              'getAggregateRepeatMissionStatus is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('반복 미션 상태 조회 실패: $e');
    }
    return null;
  }

  Future<AggregateTeamRepeatMissionStatusResponse?>
      getAggregateTeamRepeatMissionStatus({
    required int teamId,
  }) async {
    apiUrl = '${dotenv.env['MOING_API']}/api/team/team-repeat/$teamId';

    try {
      ApiResponse<List<AggregateTeamRepeatMission>>? apiResponse =
          await call.makeRequest<List<AggregateTeamRepeatMission>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) {
          log('팀별 반복 미션 Server response: $data');
          return (data as List<dynamic>)
              .map((item) => AggregateTeamRepeatMission.fromJson(
                  item as Map<String, dynamic>))
              .toList();
        },
      );

      if (apiResponse.data != null) {
        log('팀별 반복 미션 상태 조회 성공: ${apiResponse.data}');
        return AggregateTeamRepeatMissionStatusResponse(
            isSuccess: true, message: '성공', data: apiResponse.data!);
      } else {
        if (apiResponse.errorCode == 'J0003') {
          getAggregateTeamRepeatMissionStatus(teamId: teamId);
        } else {
          throw Exception(
              'getAggregateTeamRepeatMissionStatus is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('팀별 반복 미션 상태 조회 실패: $e');
    }
    return null;
  }

  Future<TeamListResponse?> getTeamListStatus() async {
    apiUrl = '${dotenv.env['MOING_API']}/api/team/my-teamList';

    try {
      ApiResponse<List<TeamList>>? apiResponse =
          await call.makeRequest<List<TeamList>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) {
          log('팀 리스트 Server response: $data');
          return (data as List<dynamic>)
              .map((item) => TeamList.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );

      if (apiResponse.data != null) {
        log('팀 리스트 조회 성공: ${apiResponse.data}');
        return TeamListResponse(
            isSuccess: true, message: '성공', data: apiResponse.data!);
      } else {
        if (apiResponse.errorCode == 'J0003') {
          getTeamListStatus();
        } else {
          throw Exception(
              'getTeamListStatus is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('팀 리스트 조회 실패: $e');
    }
    return null;
  }

  Future<TeamFireLevelData?> getTeamFireLevel({required int teamId}) async {
    apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/my-fire';

    try {
      ApiResponse<TeamFireLevelData>? apiResponse =
          await call.makeRequest<TeamFireLevelData>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) => TeamFireLevelData.fromJson(data),
      );

      if (apiResponse.data != null) {
        return apiResponse.data;
      } else {
        if (apiResponse.errorCode == 'J0003') {
          getTeamFireLevel(teamId: teamId);
        } else {
          throw Exception(
              'getTeamFireLevel is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('팀별 불 레벨 경험치 조회: $e');
    }
    return null;
  }

  // 소모임장 강제종료
  Future<int> deleteTeam({required int teamId}) async {
    apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/disband';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'DELETE',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.data != null) {
        return apiResponse.data!['teamId'];
      } else {
        if (apiResponse.errorCode == 'J0003') {
          deleteTeam(teamId: teamId);
        } else {
          throw Exception(
              'deleteTeam is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('소모임장 강제종료 실패: $e');
    }
    return 0;
  }

  //소모임원 탈퇴
  Future<int> deleteTeamUser({required int teamId}) async {
    apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/withdraw';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'DELETE',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.data != null) {
        return apiResponse.data!['teamId'];
      } else {
        if (apiResponse.errorCode == 'J0003') {
          deleteTeam(teamId: teamId);
        } else {
          throw Exception(
              'deleteTeamUser is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('소모임원 탈퇴 실패: $e');
    }
    return 0;
  }

  Future<AlarmSettingsResponse?> getAlarmSettings() async {
    apiUrl = '${dotenv.env['MOING_API']}/api/mypage/alarm';

    try {
      ApiResponse<AlarmSettingsResponse> apiResponse =
          await call.makeRequest<AlarmSettingsResponse>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) => AlarmSettingsResponse.fromJson(data),
      );

      if (apiResponse.data != null) {
        log('알람 설정 조회 성공: ${apiResponse.data}');
        return apiResponse.data;
      } else {
        if (apiResponse.errorCode == 'J0003') {
          getAlarmSettings();
        } else {
          throw Exception(
              'getAlarmSettings is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('알람 설정 조회 실패1: $e');
    }
    return null;
  }

  Future<AlarmSettingsEditor?> updateAlarmSettings(
      String type, bool status) async {
    print('type : $type, status : $status');

    String apiUrl =
        '${dotenv.env['MOING_API']}/api/mypage/alarm?type=$type&status=${status ? 'on' : 'off'}';

    try {
      ApiResponse<AlarmSettingsEditor> apiResponse =
          await call.makeRequest<AlarmSettingsEditor>(
        url: apiUrl,
        method: 'PUT', // HTTP 메서드 유지
        fromJson: (data) => AlarmSettingsEditor.fromJson(data),
      );

      if (apiResponse.data != null) {
        log('알람 설정 수정 성공!');
        return apiResponse.data;
      } else {
        if (apiResponse.errorCode == 'J0003') {
          return updateAlarmSettings(type, status);
        } else {
          throw Exception(
              'updateAlarmSettings is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('알람 설정 수정 실패: $e');
    }
    return null;
  }

  Future<List<TeamMissionPhotoData>?> getTeamMissionPhotoList() async {
    apiUrl = '${dotenv.env['MOING_API']}/api/team/my-teams';

    try {
      ApiResponse<List<TeamMissionPhotoData>> apiResponse =
          await call.makeRequest<List<TeamMissionPhotoData>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) {
          return (data as List<dynamic>)
              .map((item) =>
                  TeamMissionPhotoData.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );

      if (apiResponse.data != null) {
        log('팀별 미션 사진 모아보기 성공: ${apiResponse.data}');
        return apiResponse.data;
      } else {
        if (apiResponse.errorCode == 'J0003') {
          getTeamMissionPhotoList();
        } else {
          throw Exception(
              'getTeamMissionPhotoList is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('팀별 미션 사진 모아보기 실패: $e');
    }
    return null;
  }
}
