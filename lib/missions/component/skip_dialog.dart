import 'package:flutter/material.dart';

import '../../../const/color/colors.dart';

class SkipDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const SkipDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // 맨 아래에 어떻게 붙이지
      backgroundColor: const Color(0xFF272727),
      insetPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.infinity,  // 최대 너비로 설정
            height: 220,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 24),
                  child: Image.asset(
                    'asset/image/skip_img.png',
                    width: 100,
                    height: 100,
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
          const SizedBox(height: 30), // 텍스트와 버튼 사이 간격 조절
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // 버튼 중앙 정렬
            children: [
              Expanded(
                child: Container(
                  width: 353,
                  height: 62,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(
                          color: Color(0xff353538),
                        ),
                      ),
                      elevation: 0.0,
                    ),
                    onPressed: onConfirm,
                    child: const Text(
                      '닫기',
                      style: TextStyle(
                        color: grayScaleGrey700,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
