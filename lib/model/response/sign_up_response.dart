class SignUpResponseData {
  final String accessToken;
  final String refreshToken;
  final bool registrationStatus;

  SignUpResponseData({required this.accessToken, required this.refreshToken, required this.registrationStatus});

  factory SignUpResponseData.fromJson(Map<String, dynamic> json) {
    return SignUpResponseData(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      registrationStatus: json['registrationStatus'],
    );
  }
}