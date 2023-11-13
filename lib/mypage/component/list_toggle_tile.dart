import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/mypage/component/toggle_button.dart';

class ListToggleTile extends StatefulWidget {
  final String listName;
  final String? subText;
  final bool initialValue;
  final Function(bool) onToggle;

  const ListToggleTile({
    super.key,
    required this.listName,
    this.subText,
    required this.initialValue,
    required this.onToggle,
  });

  @override
  State<ListToggleTile> createState() => ListToggleTileState();
}

class ListToggleTileState extends State<ListToggleTile> {
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
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 11.0),
          child: Text(
            widget.subText ?? '',
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: grayScaleGrey550,
            ),
          ),
        ),
        trailing: ToggleButton(
          initialValue: isOn,
          onToggle: (value) {
            setState(() {
              isOn = value;
            });
            widget.onToggle(value);
          },
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
