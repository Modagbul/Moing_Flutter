import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mypage/revoke/mypage_revoke_reason_page.dart';

class MyPageRevokePage extends StatelessWidget {
  const MyPageRevokePage({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset(
                      'asset/icons/arrow_left.svg',
                    ),
                  ),
                  SizedBox(width: 32),
                  Text(
                    '회원탈퇴',
                    style: contentTextStyle.copyWith(
                        fontWeight: FontWeight.w600, color: grayScaleGrey300),
                  ),
                ],
              ),
              SizedBox(height: 230),
              Center(
                child: Container(
                  width: 250,
                  height: 72,
                  child: Text(
                    '잠깐! 아직 소모임 탈퇴를 진행하지 않으신 것 같아요',
                    style: headerTextStyle.copyWith(color: grayScaleGrey100),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Center(
                child: Container(
                  width: 200,
                  height: 48,
                  child: Text(
                    '소모임 활동을 모두 종료한 후 MOING 서비스를 탈퇴할 수 있어요',
                    style: bodyTextStyle.copyWith(
                      color: grayScaleGrey400,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(
                        const Size(double.infinity, 62)), // 원하는 너비와 높이
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0), // borderRadius 설정
                      ),
                    ),
                  ),
                  child: Text(
                    '돌아가기',
                    style: buttonTextStyle.copyWith(
                      color: grayScaleGrey900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
