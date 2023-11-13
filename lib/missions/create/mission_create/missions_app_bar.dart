import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/missions/create/missions_create_state.dart';
import 'package:provider/provider.dart';

class MissionAppBar extends StatelessWidget {
  const MissionAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: grayBackground,
      height: 56,
      child: Row(
        children: [
          GestureDetector(
            onTap: context
                .read<MissionCreateState>()
                .showWarningDialog,
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 32),
          Text('신규미션 만들기',
              style: buttonTextStyle.copyWith(color: grayScaleGrey300)),
          Spacer(),
          GestureDetector(
            onTap: context.read<MissionCreateState>().submit,
            child: Text('만들기', style: buttonTextStyle.copyWith(
                color: (context.watch<MissionCreateState>().isMethodSelected &&
                     context.watch<MissionCreateState>().titleController.text.isNotEmpty &&
                    context.watch<MissionCreateState>().contentController.text.isNotEmpty &&
                    context.watch<MissionCreateState>().ruleController.text.isNotEmpty
                ) ? grayScaleGrey100 : grayScaleGrey500),),),
        ],
      ),
    );
  }
}
