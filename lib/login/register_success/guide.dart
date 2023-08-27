import 'package:flutter/material.dart';
import 'package:moing_flutter/login/onboarding/component/next_button.dart';
import 'package:moing_flutter/login/register_success/component/link_card.dart';
import 'package:moing_flutter/login/register_success/component/rich_text.dart';

class RegisterGuide extends StatelessWidget {
  static const routeName = '/register/guide';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 128.0,
              ),
              Text(
                '소모임에 초대받았나요?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  color: Color(0xffE8E8EF),
                ),
              ),
              SizedBox(height: 32.0,),
              RichTextGuide(),
              SizedBox(height: 20.0,),
              Text(
                '초대장이 없다면, 지금 바로 소모임을 만들어보세요.',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xff9B9999),
                ),
              ),
              SizedBox(
                height: 60.0,
              ),
              InvitationCard(),
              SizedBox(height: 110,),
              NextButton(
                  text: '나만의 소모임 만들기',
                  textStyle: TextStyle(
                    color: Color(0xffF1F1F1),
                    fontSize: 18.0,
                  ),
                  buttonStyle: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size(
                        MediaQuery.of(context).size.width, 60,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(
                          color: Color(0xff9B9999),
                        ),
                      ),
                    ),
                  ),
                  onPressed: myMoingPressed,
              ),
              SizedBox(height: 12.0,),
              Align(
                alignment: Alignment.bottomCenter,
                child: NextButton(
                  text: '가입 완료하기',
                  textStyle: TextStyle(
                    color: Color(0xff1C1B1B),
                    fontSize: 18.0,
                  ),
                  buttonStyle: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size(
                        MediaQuery.of(context).size.width, 60,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  onPressed: completePressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 나만의 소모임 만들기 클릭
  myMoingPressed() {

  }

  /// 가입 완료하기 버튼 클릭
  completePressed() {

  }
}
