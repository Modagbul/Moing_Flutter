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
    bool isClicked = categoryState.categoryStatus[widget.buttonText] ?? false;

    String currentImagePath;

    if (categoryState.selectedCategory == widget.buttonText) {
      // 현재 선택된 카테고리의 이미지 경로 업데이트
      currentImagePath = widget.imagePath.replaceAll('.png', '_col.png');
    } else {
      // 다른 카테고리의 이미지 경로 업데이트
      currentImagePath = widget.imagePath.replaceAll('_col.png', '.png');
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (categoryState.selectedCategory == widget.buttonText) {
            // 이미 선택된 카테고리를 클릭한 경우, 선택 해제
            categoryState.deselectCategory();
          } else {
            // 다른 카테고리를 클릭한 경우, 선택
            categoryState.selectCategory(widget.buttonText);
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
