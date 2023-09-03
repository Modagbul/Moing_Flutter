import 'package:flutter/material.dart';
import 'package:moing_flutter/login/category/category_state.dart';
import 'package:provider/provider.dart';
import '../../const/color/colors.dart';
import 'component/warning_dialog.dart';

class CatagoryPage extends StatelessWidget {
  static const routeName = '/catagory';

  const CatagoryPage({Key? key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryState(context: context)),
      ],
      builder: (context, _) {
        return CatagoryPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return WarningDialog(
                    title: '모임 만들기를 끝내시겠어요?',
                    content: '나가시면 입력하신 내용을 잃게 됩니다',
                    onConfirm: () {
                  Navigator.of(context).pop(true);
                },
                );
              },
            );
          },
          color: Colors.white,
          icon: Icon(Icons.close),
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 34.0),
              _Title(),
              SizedBox(height: 76.0),
              _CategoryButton(),
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
        Align(
          alignment: Alignment.centerLeft,
          child: const Text(
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

// 닉네임 중복 검사 버튼
class _CategoryButton extends StatelessWidget {
  const _CategoryButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: grayScaleGrey700,
        // foregroundColor: grayScaleGrey700,
        // disabledBackgroundColor: grayScaleGrey700,
        // disabledForegroundColor: grayScaleGrey500,
        textStyle: const TextStyle(
          color: grayScaleGrey550,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onPressed: () {},
      child: Text('버튼'),
    );
  }
}
