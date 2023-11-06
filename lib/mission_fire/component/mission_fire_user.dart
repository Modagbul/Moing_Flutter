import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_fire/mission_fire_state.dart';
import 'package:provider/provider.dart';

class MissionFireUser extends StatelessWidget {
  const MissionFireUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            context.watch<MissionFireState>().selectedUserName,
            style: contentTextStyle.copyWith(
                color: grayScaleGrey300, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          height: 72,
        ),
        GridView.builder(
            itemCount: context.watch<MissionFireState>().userNameList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 94 / 148,
              mainAxisSpacing: 28,
              crossAxisSpacing: 50,
            ),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final bool isSelected = context.watch<MissionFireState>().selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  context.read<MissionFireState>().setSelectedIndex(index);
                  print('$index번 클릭');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 94,
                      height: 94,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: coralGrey500, width: 1)
                            : null,
                        image: DecorationImage(
                          image: AssetImage('asset/image/black.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 12), // 원과 텍스트 간의 간격 조정
                    Flexible(
                      child: Text(
                        context.watch<MissionFireState>().userNameList[index],
                        style: contentTextStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? coralGrey500 : grayScaleGrey300,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }
}
