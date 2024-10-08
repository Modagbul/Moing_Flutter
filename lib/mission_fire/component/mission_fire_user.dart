import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_fire/mission_fire_state.dart';
import 'package:moing_flutter/model/response/mission/fire_person_list_repsonse.dart';
import 'package:moing_flutter/utils/image_resize/image_resize.dart';
import 'package:provider/provider.dart';
import 'package:speech_balloon/speech_balloon.dart';

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
          height: 34,
        ),
        if (context.watch<MissionFireState>().userList != null)
          if (context.watch<MissionFireState>().userList!.isNotEmpty)
            GridView.builder(
                itemCount: context.watch<MissionFireState>().userList!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 94 / 181,
                  mainAxisSpacing: 28,
                  crossAxisSpacing: 32,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final bool isSelected =
                      context.watch<MissionFireState>().selectedIndex == index;
                  final filteredUserList =
                      context.watch<MissionFireState>().userList;

                  return GestureDetector(
                    onTap: () {
                      context.read<MissionFireState>().setSelectedIndex(index);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        filteredUserList![index].fireStatus == "False"
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: SpeechBalloon(
                                  color: coralGrey500,
                                  width: 91,
                                  height: 35,
                                  borderRadius: 24,
                                  nipLocation: NipLocation.bottom,
                                  child: Center(
                                    child: Text(
                                      '발등이 활활',
                                      style: bodyTextStyle.copyWith(
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(height: 38),
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: coralGrey500, width: 1)
                                : null,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Stack(
                              children: [
                                _buildProfileImage(
                                    filteredUserList[index], context),
                                if (filteredUserList[index].fireStatus ==
                                    "False")
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: SvgPicture.asset(
                                      'asset/icons/icon_fire_graphic.svg',
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12), // 원과 텍스트 간의 간격 조정
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              filteredUserList[index].nickname,
                              style: contentTextStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color: (isSelected ||
                                        filteredUserList[index].fireStatus ==
                                            "False")
                                    ? coralGrey500
                                    : grayScaleGrey300,
                              ),
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

  Widget _buildProfileImage(FireReceiverData user, BuildContext context) {
    ColorFilter colorFilter = ColorFilter.mode(
      grayScaleGrey600.withOpacity(0.7),
      BlendMode.overlay,
    );

    return ColorFiltered(
      colorFilter: user.fireStatus == "False"
          ? colorFilter
          : const ColorFilter.mode(
              Colors.transparent,
              BlendMode.overlay,
            ),
      child: user.profileImg != null
          ? CachedNetworkImage(
              imageUrl: user.profileImg!,
              fit: BoxFit.cover,
              width: 90,
              height: 90,
              memCacheWidth: 90.cacheSize(context),
            )
          : SvgPicture.asset(
              'asset/icons/icon_user_profile.svg',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
    );
  }
}
