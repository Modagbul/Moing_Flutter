class SignUpData {
  final String nickName;
  final String? gender;
  final String? birthDate;

  SignUpData({required this.nickName, required this.gender, required this.birthDate});

  // 클래스 객체를 JSON으로 변환하기 위한 메서드
  Map<String, dynamic> toJson() => {
    'nickName': nickName,
    'gender': gender,
    'birthDate': birthDate,
  };
}