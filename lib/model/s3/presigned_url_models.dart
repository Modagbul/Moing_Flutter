class PreSignedUrl {
  String? presignedUrl;
  String? imgUrl;

  PreSignedUrl({
    this.presignedUrl,
    this.imgUrl,
});

  factory PreSignedUrl.fromJson(Map<String, dynamic> json) {
    return PreSignedUrl(
      presignedUrl: json['presignedUrl'],
      imgUrl: json['imgUrl'],
    );
  }
}