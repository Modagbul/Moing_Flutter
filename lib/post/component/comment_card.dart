import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:moing_flutter/model/comment/comment_model.dart';
import 'package:moing_flutter/post/post_detail_state.dart';
import 'package:moing_flutter/utils/image_resize/image_resize.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatelessWidget {
  final CommentData commentData;
  final String category;
  final Function? onDelete;
  final Function? onReport;

  const CommentCard({Key? key, required this.commentData, required this.category, this.onDelete, this.onReport}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(commentData: commentData, category: category, onDelete: onDelete, onReport: onReport),
          const SizedBox(height: 12.0),
          _Content(commentData: commentData),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final CommentData commentData;
  final String category;
  final Function? onDelete;
  final Function? onReport;
  const _Header({required this.commentData, required this.category, this.onDelete, this.onReport});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: commentData.writerProfileImage != null
              ? CachedNetworkImage(
                  imageUrl: commentData.writerProfileImage!,
                  fit: BoxFit.cover,
                  width: 20,
                  height: 20,
                  memCacheWidth: 20.cacheSize(context),
                  memCacheHeight: 20.cacheSize(context),
                )
              : category == 'post' 
                ? SvgPicture.asset(
                  'asset/icons/icon_user_profile.svg',
                  fit: BoxFit.cover,
                  width: 20,
                  height: 20,
                )
                : Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        color: grayScaleGrey100,
                        borderRadius: BorderRadius.circular(50)),
                  ),
        ),
        const SizedBox(width: 8.0),
        Text(
          commentData.writerNickName,
          style: const TextStyle(
            color: grayScaleGrey400,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4.0),
        if (commentData.writerIsLeader)
          SvgPicture.asset(
            'asset/icons/icon_crown.svg',
            width: 14,
            height: 14,
          ),
        const Spacer(),
        commentData.isWriter
            ? GestureDetector(
                onTap: () async {
                  if(category == 'post') {
                    await context.read<PostDetailState>().deleteComment(boardCommentId: commentData.commentId);
                  } else {
                    // 미션인 경우
                    print('미션에서 댓글 삭제');
                    onDelete?.call();
                  }
                },
                child: const Text(
                  '삭제',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: grayBlack8,
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  if(category == 'post') {
                    context.read<PostDetailState>().showReportCommentModal(
                      context: context,
                      reportType: "BCOMMENT",
                      targetId: commentData.commentId,
                    );
                  } else {
                    // 미션인 경우
                    print('미션 댓글 신고 ');
                    onReport?.call();
                  }
                },
                child: const Text(
                  '신고',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: grayBlack8,
                  ),
                ),
              ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final CommentData commentData;

  const _Content({required this.commentData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            commentData.content,
            style: const TextStyle(
              color: grayBlack3,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            commentData.createdDate,
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: grayBlack8,
            ),
          ),
        ],
      ),
    );
  }
}
