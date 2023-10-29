import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/mypage/component/toggle_button.dart';

class ListToggleTile extends StatelessWidget {
  final String listName;
  final String? subText;

  const ListToggleTile({
    super.key,
    required this.listName,
    this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      child: ListTile(
        title: Text(
          listName,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: grayScaleGrey100,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 11.0),
          child: Text(
            subText ?? '',  // null 검사 추가
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: grayScaleGrey550,
            ),
          ),
        ),
        trailing: ToggleButton(),
      ),
    );
  }
}
