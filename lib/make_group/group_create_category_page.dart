import 'package:flutter/material.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:moing_flutter/make_group/component/category_button.dart';
import 'package:moing_flutter/make_group/component/warning_dialog.dart';
import 'package:moing_flutter/make_group/group_create_category_state.dart';
import 'package:provider/provider.dart';
import '../const/color/colors.dart';
import 'group_create_start_page.dart';
import 'group_create_start_state.dart';

class GroupCreateCategoryPage extends StatefulWidget {
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
  State<GroupCreateCategoryPage> createState() =>
      _GroupCreateCategoryPageState();
}

class _GroupCreateCategoryPageState extends State<GroupCreateCategoryPage> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _isFocused = true;
          Provider.of<GroupCreateCategoryState>(context, listen: false).deselectAllCategories();
          Provider.of<GroupCreateCategoryState>(context, listen: false).selectedCategory = null;
          Provider.of<GroupCreateCategoryState>(context, listen: false).notifyListeners();
        });
      }
    });
  }


  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = Provider.of<GroupCreateCategoryState>(context);

    if (categoryState.selectedCategory != null && _focusNode.hasFocus) {
      _focusNode.unfocus();
      _controller.clear();
    }

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
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 160),
                child: Column(
                  children: [
                    const SizedBox(height: 34.0),
                    const _Title(),
                    const SizedBox(height: 76.0),
                    const CategoryButton(
                      imagePath: 'asset/icons/icon_sport.svg',
                      buttonText: '스포츠/운동',
                    ),
                    const SizedBox(height: 8.0),
                    const CategoryButton(
                      imagePath: 'asset/icons/icon_life.svg',
                      buttonText: '생활습관 개선',
                    ),
                    const SizedBox(height: 8.0),
                    const CategoryButton(
                      imagePath: 'asset/icons/icon_test.svg',
                      buttonText: '시험/취업준비',
                    ),
                    const SizedBox(height: 8.0),
                    const CategoryButton(
                      imagePath: 'asset/icons/icon_study.svg',
                      buttonText: '스터디/공부',
                    ),
                    const SizedBox(height: 8.0),
                    const CategoryButton(
                      imagePath: 'asset/icons/icon_read.svg',
                      buttonText: '독서',
                    ),
                    const SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(_focusNode);
                        categoryState.deselectAllCategories();
                        _controller.clear();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 64,
                        margin: const EdgeInsets.only(bottom: 8.0),
                        decoration: BoxDecoration(
                          color: grayScaleGrey700,
                          borderRadius: BorderRadius.circular(16.0),
                          border: _isFocused
                              ? Border.all(color: coralGrey200, width: 1.0)
                              : Border.all(color: Colors.transparent),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: TextField(
                                      focusNode: _focusNode,
                                      controller: _controller,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      cursorColor: coralGrey200,
                                      decoration: const InputDecoration(
                                        hintText: '어떤 자기계발 모임인가요? (최대 10자)',
                                        hintStyle: TextStyle(
                                          color:
                                              grayScaleGrey550,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.symmetric(
                                                horizontal:
                                                    20.0),
                                      ),
                                      maxLength: 10,
                                      onChanged: (value) {
                                        categoryState.setCustomCategory(value);
                                      },
                                    ),
                                  ),
                                  if (_controller.text
                                      .isNotEmpty)
                                    GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).requestFocus(_focusNode);
                                        categoryState.setCustomCategory('');
                                        _controller.clear();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Icon(Icons.clear,
                                            color: grayScaleGrey550),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
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
      bottomNavigationBar: buildBottomNavigationBar(context, categoryState),
    );
  }

  Widget buildBottomNavigationBar(
      BuildContext context, GroupCreateCategoryState categoryState) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: 172,
              height: 62,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: grayScaleGrey700,
                  foregroundColor: grayScaleWhite,
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
                  Navigator.of(context).pop();
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
                        categoryState.moveInfoPage();
                      }
                    : null,
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
    );
  }
}

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
