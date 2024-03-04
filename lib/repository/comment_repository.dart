import 'package:moing_flutter/dataSource/comment_data_source.dart';
import 'package:moing_flutter/model/comment/get_all_comments_response.dart';

class CommentRepository {
  final CommentDataSource _dataSource = CommentDataSource();

  Future<AllCommentData?> getAllCommentData({required int teamId, required int boardId}) {
    return _dataSource.getAllCommentData(teamId: teamId, boardId: boardId);
  }
}