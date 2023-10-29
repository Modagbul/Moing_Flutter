import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/mypage/component/joined_group_card.dart';
import 'package:moing_flutter/mypage/my_page_state.dart';
import 'package:moing_flutter/mypage/setting_page.dart';
import 'package:provider/provider.dart';

class MyPageScreen extends StatelessWidget {
  static const routeName = '/mypage';
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyPageState(context: context)),
      ],
      child: Scaffold(
        backgroundColor: grayBackground,
        appBar: _renderAppBar(context: context),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 24.0),
                _Profile(),
                const SizedBox(height: 24.0),
                _HashTag(),
                const SizedBox(height: 52.0),
                const _GroupList(groupCnt: '1'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _renderAppBar({required BuildContext context}) {
    final Image moingLogoImg = Image.asset(
      'asset/image/logo_text.png',
      width: 80.0,
      height: 32.0,
    );

    final Image notificationImg = Image.asset(
      'asset/image/notification.png',
      width: 24.0,
      height: 24.0,
    );

    final Image settingImg = Image.asset(
      'asset/image/icon_setting.png',
      width: 24.0,
      height: 24.0,
    );

    return AppBar(
      backgroundColor: grayBackground,
      elevation: 0.0,
      title: moingLogoImg,
      centerTitle: false,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(onPressed: () {}, icon: notificationImg),
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingPage()), // SettingPage로 이동
              );
            },
            icon: settingImg),
      ],
    );
  }
}

class _Profile extends StatelessWidget {
  _Profile();

  final AssetImage defaultProfileImg = const AssetImage(
    'asset/image/icon_user_profile.png',
  );

  final Image editProfileImg = Image.asset(
    'asset/image/icon_edit_circle.png',
    width: 24.0,
    height: 24.0,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: context.read<MyPageState>().profilePressed,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 40.0,
                backgroundImage: defaultProfileImg,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: editProfileImg,
              ),
            ],
          ),
        ),
        const SizedBox(width: 20.0),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '뭉뭉님',
              style: TextStyle(
                color: grayScaleGrey100,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              '아직 한줄다짐이 없어요',
              style: TextStyle(
                color: grayScaleGrey400,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
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

  final Image blackFireImg = Image.asset(
    'asset/image/icon_fire_mono_black.png',
    width: 100.0,
    height: 100.0,
  );

  final Image whiteFireImg = Image.asset(
    'asset/image/icon_fire_mono_white.png',
    width: 100.0,
    height: 100.0,
  );

  final String titleGroupNone = '내 열정의 불이 아직 없어요';
  final String titleGroupExist = '내 열정의 불은';

  final String hashTagGroupNone = '#모임 만들고 찾아보기';

  @override
  Widget build(BuildContext context) {
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
            blackFireImg,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleGroupNone,
                  style: const TextStyle(
                      color: grayScaleGrey400,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  hashTagGroupNone,
                  style: const TextStyle(
                    color: grayScaleGrey400,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupList extends StatelessWidget {
  final String groupCnt;

  const _GroupList({
    required this.groupCnt,
  });

  @override
  Widget build(BuildContext context) {
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
              groupCnt,
              style: const TextStyle(
                color: grayScaleWhite,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        groupCnt == '0'
            ? const Text(
                '아직 참여한 소모임이 없어요',
                style: TextStyle(
                  color: grayScaleGrey400,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              )
            : const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    JoinedGroupCard(),
                    SizedBox(width: 8.0),
                    JoinedGroupCard(),
                  ],
                ),
              ),
      ],
    );
  }
}
