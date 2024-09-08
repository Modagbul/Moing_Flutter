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
import '../response/blocked_member_response.dart';
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
          await Future.delayed(const Duration(seconds: 1));
          getSingleBoard(teamId: teamId);
        } else {
          log('getSingleBoard data is Null, error code : ${apiResponse.errorCode}');
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
        return apiResponse.data!;
      } else {
        log('getMyPageData is Null, error code : ${apiResponse.errorCode}');
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
        log('ApiResponse.data is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('프로필 데이터 조회 실패: $e');
    }
    return null;
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
        log('getAllPostData is Null, error code : ${apiResponse.errorCode}');
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
          return (data as List<dynamic>)
              .map((item) =>
                  RepeatMission.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );

      if (apiResponse.data != null) {
        return RepeatMissionStatusResponse(
            isSuccess: true, message: '성공', data: apiResponse.data!);
      } else {
        log('getRepeatMissionStatus is Null, error code : ${apiResponse.errorCode}');
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
        log('postCreatePostOrNotice is Null, error code : ${apiResponse.errorCode}');
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
        log('getDetailPostData is Null, error code : ${apiResponse.errorCode}');
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
          return (data as List<dynamic>)
              .map((item) => Mission.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );

      if (apiResponse.data != null) {
        return BoardSingleMissionResponse(
            isSuccess: true, message: '성공', data: apiResponse.data!);
      } else {
        log('getSingleMissionStatus is Null, error code : ${apiResponse.errorCode}');
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
        log('getAllCommentData is Null, error code : ${apiResponse.errorCode}');
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
        log('getCompletedMissionStatus is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('완료된 미션 상태 조회 실패: $e');
    }
    return null;
  }

  Future<bool?> postCreateComment({
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
        return true;
      } else {
        log('postCreateComment is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('게시글 댓글 생성 실패: $e');
    }
    return false;
  }

  Future<bool?> deleteComment({
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
        return apiResponse.isSuccess;
      } else {
        log('deleteComment is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('게시글 댓글 삭제 실패: $e');
    }
    return false;
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
        log('deletePost is Null, error code : ${apiResponse.errorCode}');
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
        log('putUpdatePostOrNotice is Null, error code : ${apiResponse.errorCode}');
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
        log('signOut is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('로그아웃 실패: $e');
    }
    return false;
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
        return AggregateSingleMissionResponse(
            isSuccess: true, message: '성공', data: apiResponse.data!);
      } else {
        log('getAggregateSingleMissionStatus is Null, error code : ${apiResponse.errorCode}');
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
        return AggregateTeamSingleMissionResponse(
            isSuccess: true, message: '성공', data: apiResponse.data!);
      } else {
        log('getAggregateTeamSingleMissionStatus is Null, error code : ${apiResponse.errorCode}');
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
        return AggregateRepeatMissionStatusResponse(
            isSuccess: true, message: '성공', data: apiResponse.data!);
      } else {
        log('getAggregateRepeatMissionStatus is Null, error code : ${apiResponse.errorCode}');
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
        log('getAggregateTeamRepeatMissionStatus is Null, error code : ${apiResponse.errorCode}');
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
        log('getTeamListStatus is Null, error code : ${apiResponse.errorCode}');
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
        log('getTeamFireLevel is Null, error code : ${apiResponse.errorCode}');
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
        log('deleteTeam is Null, error code : ${apiResponse.errorCode}');
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
        log('deleteTeamUser is Null, error code : ${apiResponse.errorCode}');
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
        log('getAlarmSettings is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('알람 설정 조회 실패1: $e');
    }
    return null;
  }

  Future<AlarmSettingsEditor?> updateAlarmSettings(
      String type, bool status) async {
    log('type : $type, status : $status');

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
        log('updateAlarmSettings is Null, error code : ${apiResponse.errorCode}');
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
        log('getTeamMissionPhotoList is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('팀별 미션 사진 모아보기 실패: $e');
    }
    return null;
  }

  Future<String?> getNotReadAlarmCount() async {
    String apiUrl = '${dotenv.env['MOING_API']}/api/history/alarm/count';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.data != null) {
        log('안읽음 알림 개수 조회 성공!');
        return apiResponse.data!['count'];
      } else {
        log('getNotReadAlarmCount is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('안읽음 알림 개수 조회 실패: $e');
    }
    return null;
  }

  /// 게시물/댓글/미션 신고 API
  Future<bool?> postReportPost(
      {required String reportType, required int targetId}) async {
    String apiUrl =
        '${dotenv.env['MOING_API']}/api/report/$reportType/$targetId';
    try {
      ApiResponse<int> apiResponse = await call.makeRequest<int>(
        url: apiUrl,
        method: 'POST',
        fromJson: (data) => data as int,
      );

      if (apiResponse.isSuccess) {
        log('게시물/댓글/미션 신고 성공!');
        return true;
      } else {
        log('postReportPost is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('게시물/댓글/미션 신고 실패: $e');
    }
    return false;
  }

  /// 유저 차단 API
  Future<bool?> postBlockUser({required int targetId}) async {
    String apiUrl = '${dotenv.env['MOING_API']}/api/block/$targetId';

    try {
      ApiResponse<int> apiResponse = await call.makeRequest<int>(
        url: apiUrl,
        method: 'POST',
        fromJson: (data) => data as int,
      );

      if (apiResponse.isSuccess) {
        log('유저 차단 성공!');
        return true;
      } else {
        log('postBlockUser is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('유저 차단 실패: $e');
    }
    return false;
  }

  /// 차단 유저 목록 조회 API
  Future<List<int>?> getBlockUserList() async {
    String apiUrl = '${dotenv.env['MOING_API']}/api/block/';

    try {
      ApiResponse<List<int>> apiResponse = await call.makeRequest<List<int>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) {
          if (data is List<dynamic>) {
            return data.cast<int>();
          } else {
            return <int>[];
          }
        },
      );

      if (apiResponse.isSuccess) {
        log('차단 유저 목록 조회 성공!');
        return apiResponse.data;
      } else {
        log('getBlockUserList is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('차단 유저 목록 조회 실패: $e');
    }
    return null;
  }

  /// 차단 유저 정보 조회 API
  Future<List<BlockedMemberInfo>?> getBlockedMemberStatus() async {
    String apiUrl = '${dotenv.env['MOING_API']}/api/block/info';

    try {
      ApiResponse<List<BlockedMemberInfo>>? apiResponse =
          await call.makeRequest<List<BlockedMemberInfo>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) {
          print('Raw API Data: $data');

          return (data as List<dynamic>)
              .map((item) =>
                  BlockedMemberInfo.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );

      print('API Response Data: ${apiResponse.data}');

      if (apiResponse.data != null) {
        log('차단 유저 정보 조회 성공: ${apiResponse.data}');
        return apiResponse.data;
      } else {
        log('getBlockedMemberStatus is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e, stackTrace) {
      print('오류 발생: $e');
      print('StackTrace: $stackTrace');
    }

    return null;
  }

  Future<bool> createMissionComment({required CreateCommentData createCommentData,
    required int missionArchiveId, required int teamId}) async {
    String? apiUrl = '${dotenv.env['MOING_API']}/api/$teamId/$missionArchiveId/mcomment';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'POST',
        body: createCommentData.toJson(),
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.data != null) {
        log('미션 댓글 생성 성공: ${apiResponse.data}');
        return true;
      } else {
        log('createMissionComment is Null, error code : ${apiResponse.errorCode}');
        return false;
      }
    } catch (e) {
      log('나의 인증 댓글 조회 실패: $e');
      return false;
    } finally {
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
}
