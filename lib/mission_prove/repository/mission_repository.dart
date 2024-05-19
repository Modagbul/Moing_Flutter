import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/comment/comment_model.dart';

class MissionRepository {
  bool onLoading = false;
  final APICall call = APICall();
  String apiUrl = '';

  /// 미션 상세내용 모달 전체 댓글 조회
  Future<List<CommentData>?> loadMyMissionCommentData({required int teamId, required int missionArchiveId}) async {
    String? apiUrl = '${dotenv.env['MOING_API']}/api/$teamId/$missionArchiveId/mcomment';
    try {
      ApiResponse<List<CommentData>> apiResponse =
      await call.makeRequest<List<CommentData>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (dataJson) => List<CommentData>.from(
          (dataJson['commentBlocks'] as List).map(
                (item) => CommentData.fromJson(item as Map<String, dynamic>),
          ),
        ),
      );

      if (apiResponse.isSuccess == true) {
        return apiResponse.data!;
      } else {
        print('List<MissionCommentData>? is Null, error code : ${apiResponse.errorCode}');
        return null;
      }
    } catch (e) {
      log('나의 인증 댓글 조회 실패: $e');
      return null;
    } finally {
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  /// 미션 댓글 삭제
  Future<bool?> deleteComment({
    required int teamId,
    required int missionArchiveId,
    required int missionCommentId,
  }) async {
    apiUrl = '${dotenv.env['MOING_API']}/api/$teamId/$missionArchiveId/mcomment/$missionCommentId';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'DELETE',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess) {
        log('미션 댓글 삭제 성공');
        return apiResponse.isSuccess;
      } else {
        log('missionDeleteComment is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('미션 댓글 삭제 실패: $e');
    }
    return false;
  }

  /// 미션 신고
  /// 게시물/댓글/미션 신고 API
  Future<bool?> ReportMissionComment(
      {required String reportType, required int targetId}) async {
    String apiUrl = '${dotenv.env['MOING_API']}/api/report/$reportType/$targetId';
    try {
      ApiResponse<int> apiResponse = await call.makeRequest<int>(
        url: apiUrl,
        method: 'POST',
        fromJson: (data) => data as int,
      );

      if (apiResponse.isSuccess) {
        log('$reportType 신고 성공!');
        return true;
      } else {
        log('ReportMissionComment is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('$reportType 신고 실패: $e');
    }
    return false;
  }
}