import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/utils/global/api_generic.dart';
import 'package:moing_flutter/utils/global/api_response.dart';
import 'package:moing_flutter/model/comment/get_all_comments_response.dart';

class CommentDataSource {
  String apiUrl = '';
  APICall call = APICall();

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
}