import 'package:flutter/material.dart';

import '../../../const/color/colors.dart';

class WarningDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  WarningDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFF272727),
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // 아이콘과 텍스트 중앙 정렬
            children: [
              Icon(
                Icons.warning,
                size: 48, // 아이콘 크기 조절
                color: Colors.white, // 아이콘 색상 설정
              ),
              SizedBox(width: 20), // 아이콘과 텍스트 사이 간격 조절
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12), // 텍스트와 버튼 사이 간격 조절
          Text(
            content,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12), // 텍스트와 버튼 사이 간격 조절
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // 버튼 중앙 정렬
            children: [
              ElevatedButton(
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
                    side: BorderSide(
                      color: Color(0xff353538),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('나가기'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: grayScaleWhite,
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(
                      color: grayScaleWhite,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('계속 진행하기'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
