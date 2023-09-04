import 'package:flutter/material.dart';

import '../../../const/color/colors.dart';
class CategoryButton extends StatefulWidget {
  final String imagePath;
  final String buttonText;

  CategoryButton({
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
    return Container(
      width: 353,
      height: 64,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: grayScaleGrey700,
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(
              color: isClicked ? Colors.white : Colors.transparent,
              width: 1.0,
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            isClicked = !isClicked; // 버튼 클릭 상태 변경
            if (isClicked) {
              // 클릭되었을 때 이미지 경로 변경
              currentImagePath = widget.imagePath.replaceAll('.png', '_col.png');
            } else {
              // 클릭 해제되었을 때 다시 원래 이미지로 변경
              currentImagePath = widget.imagePath;
            }
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 38),
            Image.asset(
              currentImagePath, // 현재 이미지 경로 사용
              fit: BoxFit.contain,
              width: 24,
              height: 24,
            ),
            SizedBox(width: 46),
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
    );
  }
}
