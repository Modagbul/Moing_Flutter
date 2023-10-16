import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/login/gender/sign_up_gender_page.dart';
import 'package:moing_flutter/login/register_success/welcome_page.dart';

class SignUpState extends ChangeNotifier {
  final BuildContext context;

  final TextEditingController nicknameController = TextEditingController();
  Color nicknameColor = grayScaleGrey550;
  String nicknameInfo = '(0/10)';
  String nicknameCheckButtonText = '닉네임 중복 확인';
  String prevSubmitNickname = '';

  // 닉네임 중복 확인을 위한 더미 데이터 - 삭제 예정
  final nicknameList = ["A", "aB", "ABC"];

  SignUpState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "SignUpState" has been created');
  }

  @override
  void dispose() {
    nicknameController.dispose();
    log('Instance "SignUpState" has been removed');
    super.dispose();
  }

  // 닉네임 컬러, 닉네임 정보, 닉네임 버튼 텍스트 초기화 메소드
  void initNickname() {
    // 닉네임 컬러 - 기본 색상으로 변경
    nicknameColor = grayScaleGrey550;
    // 닉네임 정보 - 닉네임 길이에 맞게 변경
    nicknameInfo = '(${nicknameController.text.length}/10)';
    // 닉네임 버튼 텍스트 - 초기화
    nicknameCheckButtonText = '닉네임 중복 확인';
  }

  // 닉네임 입력 변경 감지 메소드
  void updateNickname() {
    initNickname();
    notifyListeners();
  }

  // 닉네임 유효성 체크 메소드 (닉네임 길이는 1~10)
  bool isNicknameValid() {
    String nickname = nicknameController.value.text;
    return nickname.isNotEmpty && nickname.length <= 10;
  }

  // 닉네임 입력 초기화 메소드
  void clearNickname() {
    // 닉네임 초기화
    nicknameController.clear();
    initNickname();
    notifyListeners();
  }

  // 닉네임 중복 체크 메소드
  void checkNickname(String nickname) {
    bool isDuplicate = nicknameList.contains(nickname);

    // 중복된 닉네임일 경우
    if (isDuplicate) {
      // 닉네임 정보 - 경고 텍스트
      nicknameInfo = '중복된 닉네임이에요';
      // 닉네임 컬러 - 경고 색상
      nicknameColor = errorColor;
      // 닉네임 버튼 텍스트 - '닉네임 중복 확인'으로 초기화
      nicknameCheckButtonText = '닉네임 중복 확인';
      notifyListeners();
      return;
    }

    // 중복 x, 다음으로 넘어갈 준비가 된 버튼일 경우 - 화면 이동
    if (nicknameCheckButtonText == '다음으로' && prevSubmitNickname == nickname) {
      log('닉네임($nickname) 저장 및 화면 이동');
      //Navigator.pushNamed(context, WelcomePage.routeName);
      Navigator.pushNamed(context, SignUpGenderPage.routeName);
      notifyListeners();
      return;
    }

    // 중복된 닉네임이 아닐 경우 - 다음으로 넘어갈 준비
    // 닉네임 정보 - 허용 텍스트
    nicknameInfo = '사용 가능한 닉네임이에요';
    // 닉네임 컬러 - 허용 컬러
    nicknameColor = subLight2;
    // 닉네임 버튼 텍스트 - '다음으로'
    nicknameCheckButtonText = '다음으로';
    // 제출한 닉네임 저장
    prevSubmitNickname = nicknameController.value.text;

    notifyListeners();
  }
}
