class PostData {
  final int boardId;
  final String writerNickName;
  final bool writerIsLeader;
  final String? writerProfileImage;
  final String title;
  final String content;
  final int commentNum;
  final bool isRead;
  final bool writerIsDeleted;

  PostData({
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

  factory PostData.fromJson(Map<String, dynamic> json) {
    return PostData(
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
