import 'package:moing_flutter/model/comment/comment_model.dart';

class AllCommentData {
  final List<CommentData> commentBlocks;

  AllCommentData({
    required this.commentBlocks,
  });

  factory AllCommentData.fromJson(Map<String, dynamic> json) {
    var commentBlockList = json['commentBlocks'] as List;

    return AllCommentData(
        commentBlocks: commentBlockList
            .map((block) => CommentData.fromJson(block))
            .toList());
  }
}
