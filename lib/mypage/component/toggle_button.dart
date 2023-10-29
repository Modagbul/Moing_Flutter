import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';

class ToggleButton extends StatefulWidget {
  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool isOn = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108.0,  // 가로 길이
      height: 47.0,  // 세로 길이
      decoration: BoxDecoration(
        color: grayScaleGrey600,  // 배경색
        borderRadius: BorderRadius.circular(18.0),  // 모서리 둥글기 정도
      ),
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  isOn = true;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: isOn ? grayScaleGrey100 : grayScaleGrey600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: Size(44.0, 34.0),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'ON',
                style: TextStyle(
                  fontSize: 14,
                  color: isOn ? grayScaleGrey700 : grayScaleGrey550,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isOn = false;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: !isOn ? grayScaleGrey100 : grayScaleGrey600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: Size(44.0, 34.0),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'OFF',
                style: TextStyle(
                  fontSize: 14,
                  color: !isOn ? grayScaleGrey700 : grayScaleGrey550,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
