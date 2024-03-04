import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/model/post/post_model.dart';

class PostCard extends StatelessWidget {
  final PostData postData;

  const PostCard({
    super.key,
    required this.postData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _renderNoticeCardHeader(nickName: postData.writerNickName),
          const SizedBox(height: 8.0),
          _renderNoticeCardBody(
            title: postData.title,
            content: postData.content,
            isRead: postData.isRead,
          ),
          const SizedBox(height: 12.0),
          _renderNoticeCardFooter(commentNum: postData.commentNum),
        ],
      ),
    );
  }

  Widget _renderNoticeCardHeader({required String nickName}) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: postData.writerProfileImage != null
              ? Image.network(
                  postData.writerProfileImage!,
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
          nickName,
          style: const TextStyle(
            color: grayScaleGrey400,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4.0),
        if (postData.writerIsLeader)
          SvgPicture.asset(
            'asset/icons/icon_crown.svg',
            width: 14,
            height: 14,
          ),
        const Spacer(),
        const SizedBox(height: 48.0),
      ],
    );
  }

  Widget _renderNoticeCardBody({
    required String title,
    required String content,
    required bool isRead,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  color: grayScaleWhite,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4.0),
            if (!isRead)
              SvgPicture.asset(
                'asset/icons/icon_new.svg',
                width: 16,
                height: 16,
              ),
          ],
        ),
        Text(
          content,
          style: const TextStyle(
            color: grayScaleGrey400,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _renderNoticeCardFooter({required int commentNum}) {
    return Row(
      children: [
        SvgPicture.asset(
          'asset/icons/icon_message.svg',
          width: 14,
          height: 14,
        ),
        const SizedBox(width: 4.0),
        Text(
          '$commentNum',
          style: const TextStyle(
            color: grayScaleGrey400,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
