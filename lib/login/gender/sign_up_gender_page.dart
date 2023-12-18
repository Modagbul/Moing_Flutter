import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/login/gender/sign_up_gender_state.dart';
import 'package:provider/provider.dart';

class SignUpGenderPage extends StatelessWidget {
  static const routeName = '/sign/up/gender';

  const SignUpGenderPage({super.key});

  static route(BuildContext context) {
    final String nickname =
        ModalRoute.of(context)?.settings.arguments as String;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              SignUpGenderState(nickname: nickname, context: context),
        ),
      ],
      builder: (context, _) {
        return const SignUpGenderPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: grayBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(
            'asset/icons/arrow_left.svg',
            width: 24.0,
            height: 24.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: context.read<SignUpGenderState>().skipPressed,
            child: const Text(
              '건너뛰기',
              style: TextStyle(
                color: grayScaleGrey100,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      backgroundColor: grayBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 64,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: grayScaleGrey600,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  '간단 프로필 등록 1/2',
                  style: TextStyle(
                    color: grayScaleGrey550,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                '${context.watch<SignUpGenderState>().nickname}님의',
                style: headerTextStyle,
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                '성별을 알려주세요.',
                style: headerTextStyle,
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                '불편하시다면 다음 단계로 넘어가주세요!',
                style: TextStyle(
                  color: grayScaleGrey550,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 43,
              ),
              _buildMissionButton(context: context, gender: '남자'),
              const SizedBox(
                height: 13,
              ),
              _buildMissionButton(context: context, gender: '여자'),
              const SizedBox(
                height: 13,
              ),
              _buildMissionButton(context: context, gender: '기타'),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    minimumSize: MaterialStateProperty.all<Size>(
                        const Size(double.infinity, 62)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    backgroundColor:
                        context.watch<SignUpGenderState>().isSelected == true
                            ? MaterialStateProperty.all(Colors.white)
                            : MaterialStateProperty.all(grayScaleGrey700),
                  ),
                  onPressed: () {
                    context.read<SignUpGenderState>().nextPressed();
                  },
                  child: Text(
                    '다음으로',
                    style: context.watch<SignUpGenderState>().isSelected == true
                        ? buttonTextStyle
                        : buttonTextStyle.copyWith(
                            color: grayScaleGrey500,
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

  Widget _buildMissionButton(
      {required BuildContext context, required String gender}) {
    final bool isSelected =
        context.watch<SignUpGenderState>().selectedGender == gender;

    return ElevatedButton(
      onPressed: () {
        context.read<SignUpGenderState>().setGender(gender);
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        minimumSize:
            MaterialStateProperty.all<Size>(const Size(double.infinity, 60)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        side: MaterialStateProperty.all(
          BorderSide(
            color: isSelected ? Colors.white : Colors.black,
            width: 1.0,
          ),
        ),
        backgroundColor: MaterialStateProperty.all(grayScaleGrey700),
      ),
      child: Text(
        gender,
        style: isSelected
            ? contentTextStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: grayScaleGrey300,
              )
            : contentTextStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: grayScaleGrey550,
              ),
      ),
    );
  }
}
