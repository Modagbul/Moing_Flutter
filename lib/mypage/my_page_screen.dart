import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/model/response/get_my_page_data_response.dart';
import 'package:moing_flutter/mypage/component/joined_group_card.dart';
import 'package:moing_flutter/mypage/my_page_state.dart';
import 'package:moing_flutter/utils/image_resize/image_resize.dart';
import 'package:provider/provider.dart';

class MyPageScreen extends StatelessWidget {
  static const routeName = '/mypage';

  const MyPageScreen({super.key});

  static route({required BuildContext context}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyPageState(context: context)),
      ],
      builder: (context, _) {
        return const MyPageScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const Spacer(),
              _Profile(),
              const SizedBox(height: 36.0),
              _HashTag(),
              const SizedBox(height: 52.0),
              const _GroupList(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Profile extends StatelessWidget {
  _Profile();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: context.read<MyPageState>().profilePressed,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: context.watch<MyPageState>().myPageData != null &&
                        context.watch<MyPageState>().myPageData!.profileImage !=
                            null
                    ? CachedNetworkImage(
                        imageUrl: context
                            .watch<MyPageState>()
                            .myPageData!
                            .profileImage!,
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                        memCacheWidth: 80.cacheSize(context),
                        memCacheHeight: 80.cacheSize(context),
                      )
                    : SvgPicture.asset(
                        'asset/icons/icon_user_profile.svg',
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                      ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: SvgPicture.asset(
                  'asset/icons/icon_edit_circle.svg',
                  fit: BoxFit.cover,
                  width: 32.0,
                  height: 32.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.watch<MyPageState>().myPageData?.nickName ?? '',
              style: const TextStyle(
                color: grayScaleGrey100,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4.0),
            Container(
              width: 235,
              child: Text(
                context.watch<MyPageState>().myPageData?.introduction ??
                    '아직 한줄다짐이 없어요',
                style: const TextStyle(
                  color: grayScaleGrey400,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HashTag extends StatelessWidget {
  _HashTag();

  final Widget blackFireImg = SvgPicture.asset(
    'asset/icons/icon_fire_mono_black.svg',
    width: 100,
    height: 100,
  );

  final Widget whiteFireImg = SvgPicture.asset(
    'asset/icons/icon_fire_mono_white.svg',
    width: 100,
    height: 100,
  );

  final String titleGroupNone = '내 열정의 불이 아직 없어요';
  final String titleGroupExist = '내 열정의 불은';

  final String hashTagGroupNone = '#모임 만들고 찾아보기';

  @override
  Widget build(BuildContext context) {
    MyPageData? myPageData = context.watch<MyPageState>().myPageData;

    return Container(
      decoration: const BoxDecoration(
        color: grayScaleGrey900,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 24.0,
        ),
        child: Row(
          children: [
            myPageData?.getMyPageTeamBlocks.isEmpty ?? true
                ? blackFireImg
                : whiteFireImg,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  myPageData?.categories.isEmpty ?? true
                      ? titleGroupNone
                      : titleGroupExist,
                  style: const TextStyle(
                      color: grayScaleGrey400,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600),
                ),
                myPageData?.categories.isEmpty ?? true
                    ? Text(
                        hashTagGroupNone,
                        style: const TextStyle(
                          color: grayScaleGrey400,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: myPageData?.categories
                                .take(2)
                                .map(
                                  (category) => Text(
                                    '# ${context.read<MyPageState>().convertCategoryName(category: category)}',
                                    style: const TextStyle(
                                      color: grayScaleWhite,
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                                .toList() ??
                            <Widget>[],
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupList extends StatelessWidget {
  const _GroupList();

  @override
  Widget build(BuildContext context) {
    MyPageData? myPageData = context.watch<MyPageState>().myPageData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '참여한 소모임',
              style: TextStyle(
                color: grayScaleGrey400,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              myPageData?.getMyPageTeamBlocks.length.toString() ?? '0',
              style: const TextStyle(
                color: grayScaleWhite,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        myPageData?.getMyPageTeamBlocks.isEmpty ?? true
            ? const Text(
                '아직 참여한 소모임이 없어요',
                style: TextStyle(
                  color: grayScaleGrey400,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: myPageData?.getMyPageTeamBlocks
                          .map((teamBlock) => Container(
                                margin: const EdgeInsets.only(
                                  right: 8.0,
                                ), // 8.0 간격 추가
                                child: JoinedGroupCard(
                                  teamBlock: teamBlock,
                                ),
                              ))
                          .toList() ??
                      [],
                ),
              ),
      ],
    );
  }
}
