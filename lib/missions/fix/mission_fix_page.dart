import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/missions/fix/mission_fix_data.dart';
import 'package:moing_flutter/missions/fix/mission_fix_state.dart';
import 'package:moing_flutter/utils/text_field/outlined_text_field.dart';
import 'package:provider/provider.dart';

class MissionFixPage extends StatelessWidget {
  static const routeName = '/missions/fix';

  const MissionFixPage({super.key});

  static route(BuildContext context) {
    final MissionFixData data =
        ModalRoute.of(context)?.settings.arguments as MissionFixData;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MissionFixState(context: context, fixData: data),
          lazy: false,
        ),
      ],
      builder: (context, _) {
        return const MissionFixPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayScaleGrey900,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.close,
                            size: 28,
                            color: grayScaleGrey100,
                          ),
                        ),
                        const SizedBox(width: 32),
                        Text(
                          '미션 수정하기',
                          style:
                              buttonTextStyle.copyWith(color: grayScaleGrey300),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: context.read<MissionFixState>().submit,
                          child: Text(
                            '완료',
                            style:
                                buttonTextStyle.copyWith(
                                    color: context.watch<MissionFixState>().checkSubmit
                                        ? grayScaleGrey300 : grayScaleGrey500),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '미션 제목과 내용',
                    style: contentTextStyle.copyWith(
                        fontWeight: FontWeight.w600, color: grayScaleGrey200),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '미션 제목',
                    style: bodyTextStyle.copyWith(
                        fontWeight: FontWeight.w500, color: grayScaleGrey500),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: grayScaleGrey700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      context.watch<MissionFixState>().fixData.missionTitle,
                      style: contentTextStyle.copyWith(color: grayScaleGrey500),
                    ),
                  ),
                  const SizedBox(height: 32),
                  OutlinedTextField(
                    maxLength: 300,
                    maxLines: 10,
                    hintText: '공지할 내용을 적어주세요',
                    labelText: '미션 내용',
                    onChanged: (value) =>
                        context.read<MissionFixState>().updateTextField(),
                    controller:
                        context.watch<MissionFixState>().contentController,
                    counterText:
                        '(${context.watch<MissionFixState>().contentController.text.length}/300)',
                    inputTextStyle: contentTextStyle.copyWith(color: grayBlack2),
                  ),
                  if(!context.watch<MissionFixState>().fixData.isRepeated)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const SizedBox(height: 52),
                     Text('미션 마감일',
                         style: contentTextStyle.copyWith(
                             color: grayScaleGrey200, fontWeight: FontWeight.w600)),
                     const SizedBox(height: 24),
                     Row(
                       children: [
                         GestureDetector(
                           onTap: context.read<MissionFixState>().datePicker,
                           child: Container(
                             padding: const EdgeInsets.only(left: 16),
                             width: 271,
                             height: 60,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(8),
                               color: grayScaleGrey700,
                             ),
                             child: Row(
                               children: [
                                 Text(
                                   context.watch<MissionFixState>().formattedDate.length > 1
                                       ? context.watch<MissionFixState>().formattedDate
                                       : '마감 날짜 선택하기',
                                   style: contentTextStyle.copyWith(
                                       color: grayScaleGrey100),
                                 ),
                                 const Spacer(),
                                 const Padding(
                                     padding: EdgeInsets.only(right: 16),
                                     child: Icon(
                                       Icons.calendar_month_outlined,
                                       color: Colors.white,
                                     )),
                               ],
                             ),
                           ),
                         ),
                         const Spacer(),
                         GestureDetector(
                           onTap: context.read<MissionFixState>().timePicker,
                           child: Container(
                             alignment: Alignment.center,
                             width: 75,
                             height: 60,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(8),
                               color: grayScaleGrey700,
                             ),
                             child: Text(
                               context.watch<MissionFixState>().formattedTime.length > 1
                                   ? context.watch<MissionFixState>().formattedTime
                                   : '12:00',
                               style: contentTextStyle.copyWith(
                                   color: grayScaleGrey100),
                             ),
                           ),
                         ),
                       ],
                     ),
                   ],
                  ),
                  const SizedBox(height: 32),
                  OutlinedTextField(
                    maxLength: 100,
                    maxLines: 10,
                    hintText: '모임원들에게 미션을 인증할 수 있는 방법을 알려주세요',
                    labelText: '인증 규칙',
                    onChanged: (value) =>
                        context.read<MissionFixState>().updateTextField(),
                    controller:
                    context.watch<MissionFixState>().ruleController,
                    counterText:
                    '(${context.watch<MissionFixState>().ruleController.text.length}/100)',
                    inputTextStyle: contentTextStyle.copyWith(color: grayBlack2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
