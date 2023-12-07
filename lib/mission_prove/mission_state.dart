import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/missions/fix/mission_fix_data.dart';
import 'package:moing_flutter/missions/fix/mission_fix_page.dart';
import 'package:moing_flutter/utils/button/white_button.dart';

class MissionState {
  /// 미션 더보기 클릭 시
  Future<bool> showMoreDetails({
    required BuildContext context,
    required String missionTitle,
    required String missionContent,
    required String missionRule,
    required String dueTo,
    required bool isRepeated,
    required int teamId,
    required int missionId,
    required int repeatCount,
    required String missionWay,
}) async {
    MissionFixData data = MissionFixData(
        missionTitle: missionTitle,
        missionContent: missionContent,
        missionDueto: dueTo,
        missionRule: missionRule,
      isRepeated: isRepeated,
      teamId: teamId,
      missionId: missionId,
      repeatCount: repeatCount,
      missionWay: missionWay,
    );

    var modalResult = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 275,
          decoration: const BoxDecoration(
            color: grayScaleGrey600,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    print('반복미션 종료하기 클릭');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'asset/icons/repeat_mission_end.svg',
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 24),
                        Text(
                          '반복미션 종료하기',
                          style: middleTextStyle.copyWith(color: grayScaleGrey100),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    print('미션 수정하기 클릭');
                    var result = await Navigator.of(context).pushNamed(MissionFixPage.routeName, arguments: data);
                    if(result != null && result == true) {
                      Navigator.of(context).pop(true);
                    }
                    else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'asset/icons/mission_skip.svg',
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 24),
                        Text(
                          '미션 수정하기',
                          style: middleTextStyle.copyWith(color: grayScaleGrey100),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0, top: 16),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 62,
                      decoration: BoxDecoration(
                        color: grayScaleGrey500,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '닫기',
                        style: buttonTextStyle.copyWith(color: grayScaleGrey300),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if(modalResult != null && modalResult == true) {
      return true;
    } else return false;
  }

  /// 미션 내용, 규칙 클릭 시
  void showContentAndRule({
      required BuildContext context,
      required String missionWay,
      required String missionContent,
      required String missionRule,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 700,
          decoration: const BoxDecoration(
            color: grayScaleGrey600,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, top: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '미션내용과 규칙',
                      style: middleTextStyle.copyWith(color: grayScaleGrey100),
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.center,
                      width: 72,
                      height: 33,
                      decoration: BoxDecoration(
                        color: grayScaleGrey500,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        missionWay,
                        style: bodyTextStyle.copyWith(color: grayScaleGrey200),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  '미션 내용',
                  style: contentTextStyle.copyWith(
                      fontWeight: FontWeight.w600, color: grayScaleGrey100),
                ),
                SizedBox(height: 4),
                Container(
                  child: Text(
                    missionContent,
                    style: bodyTextStyle.copyWith(
                        fontWeight: FontWeight.w500, color: grayScaleGrey400),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  '미션 규칙',
                  style: contentTextStyle.copyWith(
                      fontWeight: FontWeight.w600, color: grayScaleGrey100),
                ),
                SizedBox(height: 4),
                Container(
                  child: Text(
                    missionRule,
                    style: bodyTextStyle.copyWith(
                        fontWeight: FontWeight.w500, color: grayScaleGrey400),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: WhiteButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: '확인했어요'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 미션 인증하기 클릭 시 바텀 모달
 Future<String?> MissionSuccessPressed({
    required BuildContext context,
}) async {
   return await showModalBottomSheet(
     context: context,
     backgroundColor: Colors.transparent,
     builder: (BuildContext context) {
       return Container(
         width: double.infinity,
         height: 200,
         decoration: const BoxDecoration(
           color: grayScaleGrey600,
           borderRadius: BorderRadius.only(
             topLeft: Radius.circular(16),
             topRight: Radius.circular(16),
           ),
         ),
         child: Padding(
           padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               GestureDetector(
                 onTap: () {
                   print('미션 인증하기 클릭!');
                   Navigator.of(context).pop('submit');
                 },
                 child: Container(
                   width: double.infinity,
                   height: 64,
                   padding: EdgeInsets.symmetric(vertical: 16),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       SvgPicture.asset(
                         'asset/icons/mission_certificate.svg',
                         width: 32,
                         height: 32,
                         fit: BoxFit.cover,
                       ),
                       SizedBox(width: 24),
                       Text(
                         '미션 인증하기',
                         style: buttonTextStyle.copyWith(color: grayScaleGrey200),
                       ),
                     ],
                   ),
                 ),
               ),
               SizedBox(height: 16),
               GestureDetector(
                 onTap: () {
                   print('미션 건너뛰기 클릭!');
                   Navigator.of(context).pop('skip');
                 },
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     SvgPicture.asset(
                       'asset/icons/mission_skip.svg',
                       width: 32,
                       height: 32,
                       fit: BoxFit.cover,
                     ),
                     SizedBox(width: 24),
                     Text(
                       '미션 건너뛰기',
                       style: buttonTextStyle.copyWith(color: grayScaleGrey200),
                     ),
                   ],
                 ),
               ),
             ],
           ),
         ),
       );
     },
   );
 }
}