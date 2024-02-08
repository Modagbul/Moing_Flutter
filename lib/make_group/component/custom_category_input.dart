import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../const/color/colors.dart';

class CustomCategoryInput extends StatelessWidget {
  final Function(String) onTextChanged;

  const CustomCategoryInput({Key? key, required this.onTextChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: grayScaleGrey700,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Colors.white, // Adjust based on selection
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SvgPicture.asset('asset/icons/icon_etc.svg', width: 24, height: 24),
          const SizedBox(width: 20),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '어떤 자기계발 모임인가요?',
                border: InputBorder.none,
              ),
              maxLength: 10,
              onChanged: onTextChanged,
            ),
          ),
        ],
      ),
    );
  }
}
