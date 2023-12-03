import 'package:flutter/material.dart';
import 'package:moing_flutter/board/board_main_state.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/elevated_button.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/model/response/single_board_team_member_info.dart';
import 'package:provider/provider.dart';

class BoardGoalBottomSheet extends StatefulWidget {
  const BoardGoalBottomSheet({Key? key}) : super(key: key);

  @override
  State<BoardGoalBottomSheet> createState() => _BoardGoalBottomSheetState();
}

class _BoardGoalBottomSheetState extends State<BoardGoalBottomSheet> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      height: _isExpanded ? screenHeight * 0.50 : screenHeight * 0.30,
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
            if (_isExpanded)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 13.0),
                    child: Text(
                      '모임원 소개',
                      style: TextStyle(
                        color: grayScaleGrey100,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 14.0),
                    child: GestureDetector(
                      onTap: context
                          .read<BoardMainState>()
                          .navigateTeamMemberListPage,
                      child: const Text(
                        '전체보기',
                        style: TextStyle(
                          color: grayScaleGrey100,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
              child: Text(
                '${context.watch<BoardMainState>().singleBoardData?.boardNum ?? 0}',
                style: const TextStyle(
                  color: grayScaleGrey100,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: context.watch<BoardMainState>().navigatePostMainPage,
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    '${context.watch<BoardMainState>().singleBoardData?.teamInfo.numOfMember ?? 0}명',
                    style: bodyTextStyle.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    context
                            .watch<BoardMainState>()
                            .singleBoardData
                            ?.teamInfo
                            .category ??
                        '',
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
    List<TeamMemberInfo>? memberList = context
        .watch<BoardMainState>()
        .singleBoardData
        ?.teamInfo
        .teamMemberInfoList;
    const maxItems = 6;
    final remainingItems = (memberList?.length ?? 0) - maxItems;

    return Expanded(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: screenWidth,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(
              (memberList?.length ?? 0) < maxItems
                  ? (memberList?.length ?? 0)
                  : maxItems + 1,
              (index) {
                if (index < maxItems) {
                  final name = memberList?[index].nickName ?? '';
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
                } else {
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
                      '+$remainingItems', // 남은 아이템 개수 표시
                      maxLines: 1,
                      style: const TextStyle(
                        color: grayScaleGrey100,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildIntroductionColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '모임 소개',
          style: TextStyle(
            color: grayScaleGrey100,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          context
                  .watch<BoardMainState>()
                  .singleBoardData
                  ?.teamInfo
                  .introduction ??
              '아직 한줄다짐이 없어요',
          style: const TextStyle(
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
