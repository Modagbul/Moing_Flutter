import 'package:flutter/material.dart';
import 'package:moing_flutter/make_group/group_create_category_state.dart';
import 'package:provider/provider.dart';

import '../../../const/color/colors.dart';

class CategoryButton extends StatefulWidget {
  final String imagePath;
  final String buttonText;

  const CategoryButton({
    super.key,
    required this.imagePath,
    required this.buttonText,
  });

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  bool isClicked = false;
  late String currentImagePath; // 현재 이미지 경로를 저장하는 변수

  @override
  void initState() {
    super.initState();
    currentImagePath = widget.imagePath; // 초기 이미지 경로 설정
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = Provider.of<GroupCreateCategoryState>(context);

    bool isButtonDisabled = categoryState.isCategorySelected() &&
        categoryState.selectedCategory != widget.buttonText;

    return GestureDetector(
      onTap: isButtonDisabled
          ? null
          : () {
              setState(() {
                if (!isClicked) {
                  categoryState.selectCategory(widget.buttonText);
                  isClicked = true;
                  currentImagePath =
                      widget.imagePath.replaceAll('.png', '_col.png');
                } else {
                  categoryState.deselectCategory(); // 추가: 카테고리 선택 해제
                  isClicked = false;
                  currentImagePath = widget.imagePath;
                }
              });
            },
      child: Container(
        width: 353,
        height: 64,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(grayScaleGrey700),
            padding: MaterialStateProperty.all(const EdgeInsets.all(16.0)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(
                color: isClicked ? Colors.white : Colors.transparent,
                width: 1.0,
              ),
            )),
          ),
          onPressed: null, // `GestureDetector`에서 처리하므로 null로 설정
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 38),
              Image.asset(
                currentImagePath, // 현재 이미지 경로 사용
                fit: BoxFit.contain,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 46),
              Text(
                widget.buttonText,
                style: TextStyle(
                  color: isClicked ? Colors.white : grayScaleGrey550,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
