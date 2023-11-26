import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';

class ToggleButton extends StatefulWidget {
  final ValueChanged<bool> onToggle;
  final bool initialValue;

  const ToggleButton({super.key, required this.onToggle, required this.initialValue});

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108.0,
      height: 47.0,
      decoration: BoxDecoration(
        color: grayScaleGrey600,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => _toggle(true),
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
              onPressed: () => _toggle(false),
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

  void _toggle(bool value) {
    setState(() {
      isOn = value;
    });
    widget.onToggle(isOn);
  }

}
