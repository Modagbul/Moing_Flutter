class CreatePostData {
  final String title;
  final String content;
  final bool isNotice;

  CreatePostData({
    required this.title,
    required this.content,
    required this.isNotice,
  });

  factory CreatePostData.fromJson(Map<String, dynamic> json) {
    return CreatePostData(
      title: json['title'] as String,
      content: json['content'] as String,
      isNotice: json['isNotice'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'isNotice': isNotice,
    };
  }
}
