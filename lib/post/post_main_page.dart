import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/elevated_button.dart';
import 'package:moing_flutter/model/post/post_model.dart';
import 'package:moing_flutter/model/response/get_all_posts_response.dart';
import 'package:moing_flutter/post/component/notice_card.dart';
import 'package:moing_flutter/post/component/post_card.dart';
import 'package:moing_flutter/post/post_main_state.dart';
import 'package:provider/provider.dart';

class PostMainPage extends StatefulWidget {
  static const routeName = '/post/main';

  const PostMainPage({super.key});

  static route(BuildContext context) {
    final dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    final int teamId = arguments as int;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PostMainState(
            context: context,
            teamId: teamId,
          ),
        ),
      ],
      builder: (context, _) {
        return const PostMainPage();
      },
    );
  }

  @override
  State<PostMainPage> createState() => _PostMainPageState();
}

class _PostMainPageState extends State<PostMainPage> {
  @override
  Widget build(BuildContext context) {
    AllPostData? allPostData = context.watch<PostMainState>().allPostData;

    return Scaffold(
      backgroundColor: grayScaleGrey900,
      appBar: renderAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            (allPostData?.noticeNum == 0 && allPostData?.postNum == 0)
                ? const Center(
                    child: Text(
                      '아직 게시글이 없어요,\n첫 게시글을 올려보세요!',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: grayScaleGrey400,
                      ),
                    ),
                  )
                : ListView(children: const [
                    SizedBox(height: 12.0),
                    _Notice(),
                    SizedBox(height: 32.0),
                    _Post(),
                  ]),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: context.read<PostMainState>().navigatePostCreatePage,
                style: brightButtonStyle.copyWith(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('글쓰기 +'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget renderAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: grayScaleGrey900,
      elevation: 0.0,
      title: const Text('게시글 전체보기'),
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice();

  @override
  Widget build(BuildContext context) {
    List<PostData>? filteredNoticeBlocks = context.watch<PostMainState>().filteredNoticeBlocks;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 5.0,
          ),
          child: _renderNoticeHeader(noticeNum: filteredNoticeBlocks?.length ?? 0),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 175,
          child: _renderNoticeScrollBody(context: context),
        ),
      ],
    );
  }

  Widget _renderNoticeHeader({required int noticeNum}) {
    return Row(
      children: [
        SvgPicture.asset(
          'asset/icons/icon_solar_pin_bold.svg',
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 4.0),
        Text(
          '공지사항 $noticeNum',
          style: const TextStyle(
            color: coralGrey500,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }

  Widget _renderNoticeScrollBody({required BuildContext context}) {
    List<PostData>? filteredNoticeBlocks = context.watch<PostMainState>().filteredNoticeBlocks;
    PageController pageController = PageController(
      viewportFraction: 0.9,
    );

    return filteredNoticeBlocks != null && filteredNoticeBlocks.isEmpty
        ? const SizedBox(
            height: 150,
            child: Center(
              child: Text(
                '아직 공지사항이 없어요',
                style: TextStyle(
                  color: grayScaleGrey400,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        : PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            pageSnapping: true,
            itemCount: filteredNoticeBlocks?.length ?? 0,
            itemBuilder: (context, index) {
              final notice = filteredNoticeBlocks![index];

              return GestureDetector(
                onTap: () {
                  context
                      .read<PostMainState>()
                      .navigatePostDetailPage(boardId: notice.boardId);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: NoticeCard(
                    noticeData: notice,
                  ),
                ),
              );
            },
          );
  }
}

class _Post extends StatelessWidget {
  const _Post();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _renderPostHeader(),
          const SizedBox(height: 24.0),
          _renderPostScrollBody(context: context),
        ],
      ),
    );
  }

  Widget _renderPostHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '게시글',
          style: TextStyle(
            color: grayScaleGrey400,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '날짜순',
          style: TextStyle(
            color: grayScaleGrey400,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _renderPostScrollBody({required BuildContext context}) {
    List<PostData>? filteredPostBlocks = context.watch<PostMainState>().filteredPostBlocks;
    return filteredPostBlocks != null && filteredPostBlocks.isEmpty
        ? const Center(
            child: Text(
              '아직 게시글이 없어요',
              style: TextStyle(
                color: grayScaleGrey400,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : Column(
            children: List.generate(
              filteredPostBlocks?.length ?? 0,
              (index) {
                final post = filteredPostBlocks![index];

                return GestureDetector(
                  onTap: () {
                    context
                        .read<PostMainState>()
                        .navigatePostDetailPage(boardId: post.boardId);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: PostCard(
                      postData: post,
                    ),
                  ),
                );
              },
            ),
          );
  }
}
