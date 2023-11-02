class CreateCommentData {
  final String content;

  CreateCommentData({
    required this.content,
  });

  factory CreateCommentData.fromJson(Map<String, dynamic> json) {
    return CreateCommentData(
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }
}
