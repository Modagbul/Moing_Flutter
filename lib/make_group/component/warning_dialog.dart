import 'package:flutter/material.dart';

import '../../../const/color/colors.dart';

class WarningDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const WarningDialog({super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // 맨 아래에 어떻게 붙이지
      backgroundColor: const Color(0xFF272727),
      insetPadding: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 500,
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Image.asset(
                    'asset/image/danger_icon.png',// 이미지의 세로 크기를 100으로 설정
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12), // 텍스트와 버튼 사이 간격 조절
                Text(
                  content,
                  style: const TextStyle(
                    color: grayScaleGrey400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // 텍스트와 버튼 사이 간격 조절
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // 버튼 중앙 정렬
            children: [
              Container(
                width: 150,
                height: 55,
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
                      side: const BorderSide(
                        color: Color(0xff353538),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('나가기'),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: 150,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: grayScaleWhite,
                    padding: const EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(
                        color: Color(0xff353538),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    '계속 진행하기',
                    style: TextStyle(
                      color: grayScaleBlack,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
