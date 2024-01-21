import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/missions/create/missions_create_state.dart';
import 'package:provider/provider.dart';

class MissionsFooter extends StatelessWidget {
  const MissionsFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: coralGrey500,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: GestureDetector(
              onTap: context.read<MissionCreateState>().openBottomModal,
              child: Container(
                width: 222,
                height: 54,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewPadding.bottom),
                // decoration: BoxDecoration(
                //   // color: coralGrey500,
                //   borderRadius: BorderRadius.circular(32),
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '이런 미션은 어때요?',
                      style: buttonTextStyle.copyWith(color: Colors.white),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SvgPicture.asset(
                      'asset/icons/icon_arrow_circle_up.svg',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
