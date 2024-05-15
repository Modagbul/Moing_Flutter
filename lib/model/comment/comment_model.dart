import 'dart:developer';

class CommentData {
  final int commentId;
  final String content;
  final String writerNickName;
  final bool writerIsLeader;
  final String? writerProfileImage;
  final bool isWriter;
  final bool writerIsDeleted;
  final String createdDate;
  final int makerId;

  CommentData({
    required this.commentId,
    required this.content,
    required this.writerNickName,
    required this.writerIsLeader,
    required this.writerProfileImage,
    required this.isWriter,
    required this.writerIsDeleted,
    required this.createdDate,
    required this.makerId,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) {
    // log(json.toString());
    return CommentData(
      commentId: json['commentId'] as int,
      content: json['content'] as String,
      writerNickName: json['writerNickName'] as String,
      writerIsLeader: json['writerIsLeader'] as bool,
      writerProfileImage: json['writerProfileImage'] as String?,
      isWriter: json['isWriter'] as bool,
      writerIsDeleted: json['writerIsDeleted'] as bool,
      createdDate: json['createdDate'] as String,
      makerId: json['makerId'] as int,
    );
  }
}
