import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/elevated_button.dart';
import 'package:moing_flutter/const/style/text.dart';

class BoardGoalBottomSheet extends StatefulWidget {
  const BoardGoalBottomSheet({Key? key}) : super(key: key);

  @override
  State<BoardGoalBottomSheet> createState() => _BoardGoalBottomSheetState();
}

class _BoardGoalBottomSheetState extends State<BoardGoalBottomSheet> {
  final dummyNameList = [
    '채연',
    '챙귤',
    '으냥이',
    '윤지니',
    '승연승연',
    '현석현석',
    '승엽승',
    '지현',
  ];

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      height: _isExpanded ? screenHeight * 0.50 : screenHeight * 0.40,
      decoration: const BoxDecoration(
        color: grayScaleGrey600,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      duration: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isExpanded) _buildMissionButton(),
            if (!_isExpanded) _buildAnnouncementRow(),
            _buildGroupInfoRow(context: context),
            SizedBox(height: screenHeight * 0.02),
            if (_isExpanded) _buildExpandedGridView(screenWidth: screenWidth),
            if (_isExpanded) SizedBox(height: screenHeight * 0.03),
            if (_isExpanded) _buildIntroductionColumn(),
            if (_isExpanded) SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }

  void toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Widget _buildMissionButton() {
    return ElevatedButton(
      onPressed: () {},
      style: brightButtonStyle.copyWith(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('미션 인증하고 불 키우기'),
          Image.asset(
            'asset/image/icon_fire_black.png',
            width: 24.0,
            height: 24.0,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              '공지/게시글',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: grayScaleGrey100,
              ),
            ),
            const SizedBox(
              width: 12.0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 4.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: grayScaleGrey500,
              ),
              child: const Text(
                '2',
                style: TextStyle(
                  color: grayScaleGrey100,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {},
          style: defaultButtonStyle.copyWith(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
            textStyle: MaterialStateProperty.all<TextStyle>(
              const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          child: const Text('전체보기'),
        ),
      ],
    );
  }

  Widget _buildGroupInfoRow({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const Text(
              '모닥모닥불',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: grayScaleGrey100,
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            SizedBox(
              height: 14.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'asset/image/icon_user.png',
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '9명',
                    style: bodyTextStyle.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    '독서',
                    style: bodyTextStyle.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(
          width: 88.0,
          child: ElevatedButton(
            onPressed: () {
              toggleExpansion();
            },
            style: _isExpanded
                ? brightButtonStyle.copyWith(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                    ),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : defaultButtonStyle.copyWith(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                    ),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
            child: _isExpanded ? const Text('접기') : const Text('더보기'),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedGridView({required screenWidth}) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: screenWidth,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(
              dummyNameList.length,
              (index) {
                final name = dummyNameList[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: grayScaleGrey500,
                  ),
                  child: Text(
                    name,
                    maxLines: 1,
                    style: const TextStyle(
                      color: grayScaleGrey100,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildIntroductionColumn() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '모임 소개',
          style: TextStyle(
            color: grayScaleGrey100,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          '모잉을 만들기 위한 책읽는 모닥불 모임모잉을 만들기 위한 '
          '책읽는 모닥불 모임모잉을 만들기 위한 책읽는 모닥불 모임모잉을 '
          '만들기 위한 책읽는 모닥불 모임모잉을 만들기 위한 책읽는 모닥불 '
          '모임모잉을 만들기 위한 책읽는 모닥불 모임모잉을 만들기 위한 책읽는 모닥불 모임',
          style: TextStyle(
            color: grayScaleGrey400,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            height: 1.7,
          ),
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}