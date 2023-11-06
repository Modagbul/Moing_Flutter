import 'package:flutter/material.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:moing_flutter/make_group/component/category_button.dart';
import 'package:moing_flutter/make_group/component/warning_dialog.dart';
import 'package:moing_flutter/make_group/group_create_category_state.dart';
import 'package:moing_flutter/make_group/group_create_info_page.dart';
import 'package:provider/provider.dart';
import '../const/color/colors.dart';
import '../home/home_screen.dart';
import 'group_create_start_page.dart';
import 'group_create_start_state.dart';

class GroupCreateCategoryPage extends StatelessWidget {
  static const routeName = '/catagory';

  const GroupCreateCategoryPage({
    super.key,
  });

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => GroupCreateCategoryState(context: context)),
      ],
      builder: (context, _) {
        return const GroupCreateCategoryPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = Provider.of<GroupCreateCategoryState>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    WarningDialog(
                      title: '모임 만들기를 끝내시겠어요?',
                      content: '나가시면 입력하신 내용을 잃게 됩니다',
                      onConfirm: () {
                        Navigator.of(context).pop(true);
                      },
                      onCanceled: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          MainPage.routeName,
                              (route) => false,
                        );
                      },
                      leftText: '나가기',
                      rightText: '계속 진행하기',
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            children: [
              const SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 160),
                child: Column(
                  children: [
                    SizedBox(height: 34.0),
                    _Title(),
                    SizedBox(height: 76.0),
                    CategoryButton(
                      imagePath: 'asset/image/icon_sport.png', // 이미지 경로
                      buttonText: '스포츠/운동', // 버튼 텍스트
                    ),
                    SizedBox(height: 8.0),
                    CategoryButton(
                      imagePath: 'asset/image/icon_life.png', // 이미지 경로
                      buttonText: '생활습관 개선', // 버튼 텍스트
                    ),
                    SizedBox(height: 8.0),
                    CategoryButton(
                      imagePath: 'asset/image/icon_test.png', // 이미지 경로
                      buttonText: '시험/취업준비', // 버튼 텍스트
                    ),
                    SizedBox(height: 8.0),
                    CategoryButton(
                      imagePath: 'asset/image/icon_study.png', // 이미지 경로
                      buttonText: '스터디/공부', // 버튼 텍스트
                    ),
                    SizedBox(height: 8.0),
                    CategoryButton(
                      imagePath: 'asset/image/icon_read.png', // 이미지 경로
                      buttonText: '독서', // 버튼 텍스트
                    ),
                    SizedBox(height: 8.0),
                    CategoryButton(
                      imagePath: 'asset/image/icon_etc.png', // 이미지 경로
                      buttonText: '그외 자기계발', // 버튼 텍스트
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 버튼 중앙 정렬
                  children: [
                    Expanded(
                      child: Container(
                        width: 172,
                        height: 62,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: grayScaleGrey700,
                            textStyle: const TextStyle(
                              color: grayScaleGrey550,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                            padding: const EdgeInsets.all(16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          onPressed: () {
                            /// 버버벅 없앰 --> 시뮬레이터만 그런거 일수도 있어서 나중에 폰으로 봤을 때 괜찮으면 기존 간단 코드로 수정
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2) =>
                                    ChangeNotifierProvider(
                                      create: (_) => GroupCreateStartState(context: context),
                                      child: GroupCreateStartPage(),
                                    ),
                                transitionsBuilder: (context, animation1, animation2, child) {
                                  return child; // 애니메이션 없이 바로 child 위젯을 반환
                                },
                                transitionDuration: Duration(milliseconds: 0), // 전환 시간을 0으로 설정
                              ),
                            );
                          },
                          child: const Text('이전으로'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        width: 172,
                        height: 62,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: categoryState.getNextButtonColor(),
                            padding: const EdgeInsets.all(16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          onPressed: categoryState.isCategorySelected()
                              ? () {
                            // 임시로 **
                            categoryState.moveInfoPage();
                          }
                              : null, // 카테고리가 선택되지 않았다면 버튼은 비활성화 상태가 되어야 함
                          child: Text(
                            '다음으로',
                            style: TextStyle(
                              color: categoryState.getNextButtonTextColor(),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 소모임 목표 선택안내
class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: const Text(
              '소모임의 목표를 알려주세요!',
              style: TextStyle(
                color: grayScaleGrey100,
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '소모임의 카테고리를 선택해주세요',
            style: TextStyle(
              color: grayScaleGrey550,
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
