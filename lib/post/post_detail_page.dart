import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/board/component/icon_text_button.dart';
import 'package:moing_flutter/const/style/elevated_button.dart';
import 'package:moing_flutter/model/comment/comment_model.dart';
import 'package:moing_flutter/model/post/post_detail_model.dart';
import 'package:moing_flutter/model/response/get_all_comments_response.dart';
import 'package:moing_flutter/post/component/comment_card.dart';
import 'package:moing_flutter/post/post_detail_state.dart';

import 'package:provider/provider.dart';

import '../const/color/colors.dart';
import '../make_group/component/warning_dialog.dart';

class PostDetailPage extends StatelessWidget {
  static const routeName = '/post/detail';

  const PostDetailPage({Key? key}) : super(key: key);

  static route(BuildContext context) {
    final dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    final int teamId = arguments?['teamId'];
    final int boardId = arguments?['boardId'];

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PostDetailState(
            context: context,
            teamId: teamId,
            boardId: boardId,
          ),
        ),
      ],
      builder: (context, _) {
        return const PostDetailPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final PostDetailData? postDetailData =
        context.watch<PostDetailState>().postData;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: grayScaleGrey900,
        appBar: renderAppBar(context),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller:
                          context.read<PostDetailState>().scrollController,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 26.0),
                                if (postDetailData?.isNotice ?? false)
                                  _renderNoticeTag(),
                                const SizedBox(height: 12.0),
                                Text(
                                  postDetailData?.title ?? '',
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: grayScaleGrey300,
                                  ),
                                ),
                                const SizedBox(height: 32.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: postDetailData
                                                    ?.writerProfileImage !=
                                                null
                                            ? Image.network(
                                                postDetailData
                                                        ?.writerProfileImage ??
                                                    '',
                                                fit: BoxFit.cover,
                                                width: 20,
                                                height: 20,
                                              )
                                            : SvgPicture.asset(
                                                'asset/icons/icon_user_profile.svg',
                                                fit: BoxFit.cover,
                                                width: 20,
                                                height: 20,
                                              ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        postDetailData?.writerNickName ?? '',
                                        style: const TextStyle(
                                          color: grayScaleGrey400,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 4.0),
                                      if (postDetailData?.writerIsLeader ??
                                          false)
                                        SvgPicture.asset(
                                          'asset/icons/icon_crown.svg',
                                          width: 14,
                                          height: 14,
                                        ),
                                      const Spacer(),
                                      Text(
                                        postDetailData?.createdDate ?? '',
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          color: grayBlack8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  postDetailData?.content ?? '',
                                  style: const TextStyle(
                                    color: grayBlack3,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    height: 1.7,
                                  ),
                                ),
                                const SizedBox(height: 40.0),
                              ],
                            ),
                          ),
                          Container(
                            height: 8.0,
                            decoration:
                                const BoxDecoration(color: grayScaleGrey600),
                          ),
                          _renderCommentScrollBody(context: context),
                          const SizedBox(height: 150),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: grayScaleGrey700,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    child: _CommentsInputWidget(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderNoticeTag() {
    return Row(
      children: [
        SvgPicture.asset(
          'asset/icons/icon_solar_pin_bold.svg',
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 4.0),
        const Text(
          '공지사항',
          style: TextStyle(
            color: coralGrey500,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }

  PreferredSizeWidget renderAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: grayScaleGrey900,
      elevation: 0.0,
      title: const Text('게시글'),
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            context.read<PostDetailState>().postData?.isWriter ?? false
                ? showPostControlBottomSheet(context: context)
                : showPostControlBottomSheetNotWriter(context: context);
          },
          icon: const Icon(Icons.more_vert),
        )
      ],
    );
  }

  void showPostControlBottomSheetNotWriter({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      backgroundColor: grayScaleGrey600,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      builder: (_) {
        final screenHeight = MediaQuery.of(context).size.height;
        return SizedBox(
          height: screenHeight * 0.25,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: context.read<PostDetailState>().reportPost,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'asset/icons/post_alarm.svg',
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(width: 24.0),
                      const Text(
                        '게시글 신고하기',
                        style: TextStyle(
                          color: grayScaleGrey200,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: defaultButtonStyle,
                  child: const Text('닫기'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showPostControlBottomSheet({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      backgroundColor: grayScaleGrey600,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      builder: (_) {
        final screenHeight = MediaQuery.of(context).size.height;
        return SizedBox(
          height: screenHeight * 0.30,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IconTextButton(
                  onPressed: () {
                    context.read<PostDetailState>().navigatePostUpdatePage();
                  },
                  icon: 'asset/icons/icon_edit.svg',
                  text: '게시글 수정하기',
                ),
                IconTextButton(
                  onPressed: () => _showDeleteDialog(context),
                  icon: 'asset/icons/icon_delete.svg',
                  text: '게시글 삭제하기',
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: defaultButtonStyle,
                  child: const Text('닫기'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WarningDialog(
              title: '게시글을 삭제하시겠어요?',
              content: '한번 삭제한 게시글은 복구할 수 없게 됩니다',
              onConfirm: () async {
                Navigator.of(dialogContext).pop();
                await context.read<PostDetailState>().deletePost();
              },
              onCanceled: () => Navigator.of(dialogContext).pop(),
              leftText: '취소하기',
              rightText: '삭제하기',
            ),
          ],
        );
      },
    );
  }

  Widget _renderCommentScrollBody({required BuildContext context}) {
    AllCommentData? allCommentData =
        context.watch<PostDetailState>().allCommentData;
    List<CommentData> commentList = allCommentData?.commentBlocks ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 8.0,
      ),
      child: Column(
        children: commentList.map((CommentData comment) {
          return CommentCard(commentData: comment);
        }).toList(),
      ),
    );
  }
}

class _CommentsInputWidget extends StatelessWidget {
  const _CommentsInputWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _renderTextField(context: context),
        ),
        const SizedBox(width: 8.0),
        _renderSendButton(context: context),
      ],
    );
  }

  Widget _renderTextField({required BuildContext context}) {
    return TextField(
      controller: context.watch<PostDetailState>().commentController,
      onChanged: (value) => context.read<PostDetailState>().updateTextField(),
      maxLines: 1,
      inputFormatters: [LengthLimitingTextInputFormatter(200)],
      decoration: InputDecoration(
        filled: true,
        fillColor: grayScaleGrey600,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 16.0,
        ),
      ),
      style: const TextStyle(
        color: grayScaleGrey100,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: grayScaleGrey100,
    );
  }

  Widget _renderSendButton({required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
        color: grayScaleGrey600,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(6.0),
      child: IconButton(
        icon: SvgPicture.asset(
          'asset/icons/icon_send.svg',
          width: 24,
          height: 24,
        ),
        onPressed: () async {
          await context.read<PostDetailState>().postCreateComment();
        },
      ),
    );
  }
}
