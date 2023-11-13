import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/init/init_page.dart';
import 'package:moing_flutter/make_group/component/warning_dialog.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:moing_flutter/utils/api/refresh_token.dart';
import 'dart:io';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class MyPageRevokeState extends ChangeNotifier {
  final BuildContext context;
  final TextEditingController etcController = TextEditingController();
  final FocusNode etcFocus = FocusNode();

  SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();
  bool isSelected = false;
  String? selectedReason;

  MyPageRevokeState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "MyPageRevokeState" has been created');
    etcController.addListener(() {
      // 상태 업데이트
      notifyListeners();
    });
  }

  void dispose() {
    etcController.dispose();
  }

  void setReason(String reason) {
    selectedReason = reason;
    isSelected = true;
    notifyListeners();
  }

  void onClearButtonPressed() {
    etcController.clear();
    notifyListeners();
  }

  void revokePressed() {
    if (!isSelected) return ;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 370,
          decoration: const BoxDecoration(
            color: grayScaleGrey600,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/image/danger_icon.png',
                  width: 52,
                  height: 52,
                ),
                SizedBox(height: 24),
                Text('한번 더 확인해주세요!',
                    style: middleTextStyle.copyWith(color: grayScaleGrey100)),
                SizedBox(height: 12),
                Container(
                  alignment: Alignment.center,
                  width: 220,
                  height: 72,
                  child: Text(
                    'MOING을 탈퇴하면 현재까지 쌓아왔던\n소모임 데이터를 복구할 수 없게 돼요.\n탈퇴를 진행하시겠어요?',
                    style: bodyTextStyle.copyWith(fontWeight: FontWeight.w500, color: grayScaleGrey400,),
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 45),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Text('취소하기',style: buttonTextStyle.copyWith(color: Color(0xffF1F1F1))),
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                              Size(MediaQuery.of(context).size.width, 62)),
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                side: BorderSide(
                                  width: 1,
                                  color: grayScaleGrey400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: revoke,
                          child: Text('탈퇴하기', style: buttonTextStyle.copyWith(color:errorColor)),
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                                Size(MediaQuery.of(context).size.width, 62)),
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                side: BorderSide(
                                  width: 1,
                                  color: errorColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// 탈퇴 로직
  void revoke() async {
    String? sign = await sharedPreferencesInfo.loadPreferencesData('sign');
    if(sign == null) return ;

    if(selectedReason != null && selectedReason!.contains('기타')) {
      selectedReason = etcController.text;
    }

    print('로그인 제공업체 : $sign');
    print('탈퇴 사유 : $selectedReason');
    String? socialToken = await socialSign(sign: sign);
    if(socialToken == null) return ;

    final String apiUrl = '${dotenv.env['MOING_API']}/api/mypage/withdrawal/$sign';
    final APICall call = APICall();

    Map<String, dynamic> data = {
      'reason': selectedReason,
      'socialToken': socialToken,
    };

    try {
      ApiResponse<void> apiResponse = await call.makeRequest<void>(
        url: apiUrl,
        method: 'DELETE',
        body: data,
        fromJson: (_) => null,
      );
      print('회원탈퇴 성공!');
    } catch (e) {
      log('회원탈퇴 실패: $e');
    }
  }

  Future<String?> socialSign({required String sign}) async {
    if(sign == 'kakao') {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      // print(token);
      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      if(response.statusCode == 200) {
        return token.accessToken;
      }
      else {
        return null;
      }
    }
    else if (sign == 'apple') {
      bool isAvailable = await SignInWithApple.isAvailable();

      /// IOS 13 버전 이상인 경우
      if (isAvailable) {
        try {
          final appleCredential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );

          print('crendential : ${appleCredential.authorizationCode}');
          return appleCredential.authorizationCode;
        } catch (e) {
          print('애플 로그인 실패 : ${e.toString()}');
          return null;
        }
      }

      /// IOS 13 버전이 아닌 경우
      else {
        throw PlatformException(
          code: 'APPLE_SIGN_IN_NOT_AVAILABLE',
          message: 'Sign in With Apple is not available on this device.',
        );
      }
    }
  }
}
