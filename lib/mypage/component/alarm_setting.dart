import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mypage/alarm_setting_state.dart';
import 'package:provider/provider.dart';

class AlarmComponent extends StatelessWidget {
  final String title;
  double? height;
  String? subTitle;

  AlarmComponent({
    Key? key,
  required this.title,
    this.subTitle,
  this.height = 79,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.watch<AlarmSettingState>();
    bool isTrue = false;
    bool isFalse = false;

    if(title.contains('전체')) {
      isTrue = state.isTotalAlarmOn != null && state.isTotalAlarmOn!;
      isFalse = state.isTotalAlarmOn != null && !state.isTotalAlarmOn!;
    } else if (title.contains('신규 업로드')) {
      isTrue = state.isNewUploadPushOn != null && state.isNewUploadPushOn!;
      isFalse = state.isNewUploadPushOn != null && !state.isNewUploadPushOn!;
    } else if (title.contains('미션 리마인드')) {
      isTrue = state.isRemindPushOn != null && state.isRemindPushOn!;
      isFalse = state.isRemindPushOn != null && !state.isRemindPushOn!;
    } else if (title.contains('불 던지기 알림')) {
      isTrue = state.isFirePushOn != null && state.isFirePushOn!;
      isFalse = state.isFirePushOn != null && !state.isFirePushOn!;
    } else if (title.contains('댓글 알림')){
      isTrue = state.isCommentPushOn != null && state.isCommentPushOn!;
      isFalse = state.isCommentPushOn != null && !state.isCommentPushOn!;
    }

    return Container(
      height: height,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: subTitle == null ? Alignment.centerLeft : Alignment.topLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: grayScaleGrey100,
                  ),
                ),
              ),
              if(subTitle != null)
                Column(
                  children: [
                    SizedBox(height: 8),
                    Text(
                      subTitle!,
                      style: smallTextStyle.copyWith(color: grayScaleGrey550),
                    )
                  ],
                )
            ],
          ),
          Spacer(),
          Container(
            width: 115.0,
            height: 47.0,
            decoration: BoxDecoration(
              color: grayScaleGrey600,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<AlarmSettingState>().alarmSettings(title: title, isFixed: true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, top: 4, bottom: 4),
                    child: Container(
                      width: 52,
                      height: 39,
                      decoration: BoxDecoration(
                        color: isTrue ? grayScaleGrey100 : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text('ON', style:
                      isTrue ? contentTextStyle.copyWith(color: grayScaleGrey700, fontWeight: FontWeight.w600)
                          : contentTextStyle.copyWith(color: grayScaleGrey550, fontWeight: FontWeight.w600),),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<AlarmSettingState>().alarmSettings(title: title, isFixed: false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0, top: 4, bottom: 4),
                    child: Container(
                      width: 52,
                      height: 39,
                      decoration: BoxDecoration(
                        color: isFalse ? grayScaleGrey100 : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text('OFF',
                        style: isFalse
                            ? contentTextStyle.copyWith(color: grayScaleGrey700, fontWeight: FontWeight.w600)
                            : contentTextStyle.copyWith(color: grayScaleGrey550, fontWeight: FontWeight.w600),),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
