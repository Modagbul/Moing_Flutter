import 'dart:developer';

class PostDetailData {
  final int boardId;
  final String writerNickName;
  final bool writerIsLeader;
  final String? writerProfileImage;
  final String title;
  final String content;
  final String createdDate;
  final bool isWriter;
  final bool isNotice;
  final int makerId;

  PostDetailData({
    required this.boardId,
    required this.writerNickName,
    required this.writerIsLeader,
    required this.writerProfileImage,
    required this.title,
    required this.content,
    required this.createdDate,
    required this.isWriter,
    required this.isNotice,
    required this.makerId,
  });

  factory PostDetailData.fromJson(Map<String, dynamic> json) {

    log(json.toString());
    return PostDetailData(
      boardId: json['boardId'] as int,
      writerNickName: json['writerNickName'] as String,
      writerIsLeader: json['writerIsLeader'] as bool,
      writerProfileImage: json['writerProfileImage'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      createdDate: json['createdDate'] as String,
      isWriter: json['isWriter'] as bool,
      isNotice: json['isNotice'] as bool,
      makerId: json['makerId'] as int,
    );
  }
}
