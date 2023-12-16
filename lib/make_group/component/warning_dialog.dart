import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../const/color/colors.dart';

class WarningDialog extends StatelessWidget {
  final String title;
  final String content;
  final String leftText;
  final String rightText;
  final VoidCallback onConfirm;
  final VoidCallback onCanceled;

  const WarningDialog({super.key,
    required this.title,
    required this.content,
    required this.leftText,
    required this.rightText,
    required this.onConfirm,
    required this.onCanceled,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF272727),
      insetPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SvgPicture.asset(
                    'asset/icons/danger_icon.svg',
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
                    backgroundColor: grayScaleGrey600,
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
                    elevation: 0.0,
                  ),
                  onPressed: onCanceled,
                  child: Text(leftText),
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
                    elevation: 0.0,
                  ),
                  onPressed: onConfirm,
                  child: Text(
                    rightText,
                    style: const TextStyle(
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
