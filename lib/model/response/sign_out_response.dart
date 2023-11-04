class SignOutResponse {
  bool isSuccess;
  String message;

  SignOutResponse({
    required this.isSuccess,
    required this.message,
  });

  factory SignOutResponse.fromJson(Map<String, dynamic> json) {
    return SignOutResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
    );
  }
}
