import 'package:flutter/material.dart';

class RichTextGuide extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 18.0,
          color: Color(0xffFF725F),
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: '아래 버튼을 눌러 가입 완료 후\n받은 초대장 링크',
          ),
          TextSpan(
            text: '를 눌러주세요.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
