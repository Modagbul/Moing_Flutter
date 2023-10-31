import 'dart:developer';

class NoticeData {
  final int noticeNum;
  final List<NoticeBlock> noticeBlocks;
  final int notNoticeNum;
  final List<NoticeBlock> notNoticeBlocks;

  NoticeData({
    required this.noticeNum,
    required this.noticeBlocks,
    required this.notNoticeNum,
    required this.notNoticeBlocks,
  });

  factory NoticeData.fromJson(Map<String, dynamic> json) {
    log(json.toString());

    var noticeBlocksList = json['noticeBlocks'] as List;
    List<NoticeBlock> noticeBlocks =
    noticeBlocksList.map((block) => NoticeBlock.fromJson(block)).toList();

    var notNoticeBlocksList = json['notNoticeBlocks'] as List;
    List<NoticeBlock> notNoticeBlocks = notNoticeBlocksList
        .map((block) => NoticeBlock.fromJson(block))
        .toList();

    return NoticeData(
      noticeNum: json['noticeNum'],
      noticeBlocks: noticeBlocks,
      notNoticeNum: json['notNoticeNum'],
      notNoticeBlocks: notNoticeBlocks,
    );
  }
}

class NoticeBlock {
  final int boardId;
  final String writerNickName;
  final bool writerIsLeader;
  final String? writerProfileImage;
  final String title;
  final String content;
  final int commentNum;
  final bool isRead;
  final bool writerIsDeleted;

  NoticeBlock({
    required this.boardId,
    required this.writerNickName,
    required this.writerIsLeader,
    required this.writerProfileImage,
    required this.title,
    required this.content,
    required this.commentNum,
    required this.isRead,
    required this.writerIsDeleted,
  });

  factory NoticeBlock.fromJson(Map<String, dynamic> json) {
    return NoticeBlock(
      boardId: json['boardId'],
      writerNickName: json['writerNickName'],
      writerIsLeader: json['writerIsLeader'],
      writerProfileImage: json['writerProfileImage'],
      title: json['title'],
      content: json['content'],
      commentNum: json['commentNum'],
      isRead: json['isRead'],
      writerIsDeleted: json['writerIsDeleted'],
    );
  }
}
