import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mypage/revoke/mypage_revoke_state.dart';
import 'package:provider/provider.dart';

class MyPageRevokeReasonPage extends StatelessWidget {
  const MyPageRevokeReasonPage({super.key});

  static const routeName = '/mypage/revoke/reason';

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => MyPageRevokeState(context: context)),
      ],
      builder: (context, _) {
        return const MyPageRevokeReasonPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayBackground,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
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
                SizedBox(height: 34),
                Container(
                  width: 280,
                  height: 64,
                  child: Text('MOING을 탈퇴하려는 이유가 무엇인가요?',
                      style: headerTextStyle.copyWith(
                        color: grayScaleGrey100,
                        height: 1.3,
                      )),
                ),
                SizedBox(height: 56),
                _missionRevokeButton(
                    context: context, reason: '현재 모임에 참여하고 있지 않아요'),
                SizedBox(height: 8),
                _missionRevokeButton(
                    context: context, reason: '앱 이용에 불편함이 있어요'),
                SizedBox(height: 8),
                _missionRevokeButton(
                    context: context, reason: '원하는 기능이 없어서 아쉬워요'),
                SizedBox(height: 8),
                if (context.watch<MyPageRevokeState>().selectedReason == null ||
                    !context
                        .watch<MyPageRevokeState>()
                        .selectedReason!
                        .contains('기타'))
                  _missionRevokeButton(
                      context: context, reason: '기타(탈퇴사유를 입력해주세요)'),
                if (context.watch<MyPageRevokeState>().selectedReason != null &&
                    context
                        .watch<MyPageRevokeState>()
                        .selectedReason!
                        .contains('기타'))
                  Container(
                    width: double.infinity,
                    height: 64,
                    margin: const EdgeInsets.only(bottom: 8.0),
                    decoration: BoxDecoration(
                      color: grayScaleGrey700,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: TextField(
                        maxLines: 1,
                        controller:
                            context.watch<MyPageRevokeState>().etcController,
                        focusNode: context.watch<MyPageRevokeState>().etcFocus,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                              left: 16, right: 16, top: 20, bottom: 20),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),

                          // 삭제 버튼 - 값을 입력할 경우 활성화
                          suffixIcon: context
                                  .watch<MyPageRevokeState>()
                                  .etcController
                                  .text
                                  .isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close),
                                  color: grayScaleGrey550,
                                  // 버튼을 누를 경우 - 입력값 삭제
                                  onPressed: context
                                      .read<MyPageRevokeState>()
                                      .onClearButtonPressed,
                                )
                              : null,
                        ),
                        style: contentTextStyle.copyWith(
                          color: Colors.white,
                        )),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }


  Widget buildBottomNavigationBar(
      BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 16),
      child: ElevatedButton(
        onPressed: context.read<MyPageRevokeState>().revokePressed,
        style: ButtonStyle(
          overlayColor:
          MaterialStateProperty.all(Colors.transparent),
          minimumSize: MaterialStateProperty.all<Size>(
              const Size(double.infinity, 62)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          backgroundColor:
          context.watch<MyPageRevokeState>().isSelected == true
              ? MaterialStateProperty.all(Colors.white)
              : MaterialStateProperty.all(grayScaleGrey700),
        ),
        child: Text(
          '회원탈퇴',
          style:
          context.watch<MyPageRevokeState>().isSelected == true
              ? buttonTextStyle
              : buttonTextStyle.copyWith(
            color: grayScaleGrey500,
          ),
        ),
      ),
    );
  }

  Widget _missionRevokeButton(
      {required BuildContext context, required String reason}) {
    final bool isSelected =
        context.watch<MyPageRevokeState>().selectedReason == reason;
    return ElevatedButton(
      onPressed: () {
        context.read<MyPageRevokeState>().setReason(reason);
        reason.contains('기타')
            ? context.read<MyPageRevokeState>().etcFocus.requestFocus()
            : context.read<MyPageRevokeState>().etcFocus.unfocus();
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 60)),
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
        reason,
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
