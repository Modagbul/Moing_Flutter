import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';
import 'package:speech_balloon/speech_balloon.dart';

class MissionProveButton extends StatefulWidget {
  const MissionProveButton({Key? key}) : super(key: key);

  @override
  State<MissionProveButton> createState() => _MissionProveButtonState();
}

class _MissionProveButtonState extends State<MissionProveButton> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // 애니메이션 컨트롤러를 초기화합니다.
    _animationController = AnimationController(
      duration: const Duration(seconds: 2), // 애니메이션 지속 시간
      vsync: this,
    );

    // 투명도 애니메이션을 정의합니다.
    _fadeAnimation = Tween(begin: 1.0, end: 0.0).animate(_animationController);

    // 애니메이션을 시작합니다.
    Future.delayed(const Duration(milliseconds: 1000), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    // 애니메이션 컨트롤러를 해제합니다.
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      left: 20,
      right: 20,
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          Size(138, 50),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(grayScaleGrey600),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '좋아요',
                            style: contentTextStyle.copyWith(
                              color: grayScaleGrey100,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '4',
                            style: contentTextStyle.copyWith(
                              color: coralGrey500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if(context.watch<MissionProveState>().missionWay.contains('사진'))
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          Size(138, 50),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(grayScaleGrey600),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                      child: Text(
                        '공유하기',
                        style: contentTextStyle.copyWith(
                          color: grayScaleGrey100,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    Size(224, 62),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48.0),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '불 던지러 가기',
                      style: buttonTextStyle,
                    ),
                    SizedBox(width: 8),
                    Image.asset(
                      'asset/image/icon_fire_black.png',
                      height: 20,
                      width: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
          if(context.watch<MissionProveState>().isFireText)
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SpeechBalloon(
                color: coralGrey500,
                width: double.infinity,
                height: 33,
                borderRadius: 24,
                nipLocation: NipLocation.bottom,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '미션을 인증하지 않은 모임원에게 불을 던져 독려해요',
                      style: bodyTextStyle.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
