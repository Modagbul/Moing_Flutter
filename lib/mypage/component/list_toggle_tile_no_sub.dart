import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/mypage/component/toggle_button.dart';

class ListToggleTileNoSub extends StatelessWidget {
  final String listName;

  const ListToggleTileNoSub({
    super.key,
    required this.listName,
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
        trailing: ToggleButton(),
      ),
    );
  }
}
