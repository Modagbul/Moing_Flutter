
import 'package:moing_flutter/model/post/post_model.dart';

class AllPostData {
  final int noticeNum;
  final List<PostData> noticeBlocks;
  final int postNum;
  final List<PostData> postBlocks;

  AllPostData({
    required this.noticeNum,
    required this.noticeBlocks,
    required this.postNum,
    required this.postBlocks,
  });

  factory AllPostData.fromJson(Map<String, dynamic> json) {

    var noticeBlocksList = json['noticeBlocks'] as List;
    List<PostData> noticeBlocks =
    noticeBlocksList.map((block) => PostData.fromJson(block)).toList();

    var notNoticeBlocksList = json['notNoticeBlocks'] as List;
    List<PostData> notNoticeBlocks = notNoticeBlocksList
        .map((block) => PostData.fromJson(block))
        .toList();

    return AllPostData(
      noticeNum: json['noticeNum'],
      noticeBlocks: noticeBlocks,
      postNum: json['notNoticeNum'],
      postBlocks: notNoticeBlocks,
    );
  }
}

