import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/mypage/component/toggle_button.dart';

class ListToggleTileNoSub extends StatefulWidget {
  final String listName;
  final bool initialValue;
  final Function(bool) onToggle;

  const ListToggleTileNoSub({
    super.key,
    required this.listName,
    required this.initialValue,
    required this.onToggle,
  });

  @override
  State<ListToggleTileNoSub> createState() => ListToggleTileNoSubState();
}

class ListToggleTileNoSubState extends State<ListToggleTileNoSub> {
  bool isOn = true;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      child: ListTile(
        title: Text(
          widget.listName,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: grayScaleGrey100,
          ),
        ),
        trailing: ToggleButton(
          initialValue: widget.initialValue, // 현재 상태 전달
          onToggle: widget.onToggle,
        ),
      ),
    );
  }

  void updateToggleState(bool newState) {
    setState(() {
      isOn = newState;
    });
  }
}
