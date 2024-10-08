import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/model/post/post_model.dart';
import 'package:moing_flutter/utils/image_resize/image_resize.dart';

class NoticeCard extends StatelessWidget {
  final PostData noticeData;

  const NoticeCard({
    super.key,
    required this.noticeData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: const BoxDecoration(
        color: grayScaleGrey600,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, right: 14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _renderNoticeCardHeader(
                nickName: noticeData.writerNickName, context: context),
            const SizedBox(height: 8.0),
            _renderNoticeCardBody(
              title: noticeData.title,
              content: noticeData.content,
              isRead: noticeData.isRead,
            ),
            const SizedBox(height: 12.0),
            _renderNoticeCardFooter(commentNum: noticeData.commentNum),
          ],
        ),
      ),
    );
  }

  Widget _renderNoticeCardHeader(
      {required String nickName, required BuildContext context}) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: noticeData.writerProfileImage != null
              ? CachedNetworkImage(
                  imageUrl: noticeData.writerProfileImage!,
                  fit: BoxFit.cover,
                  width: 20,
                  height: 20,
                  memCacheWidth: 20.cacheSize(context),
                  memCacheHeight: 20.cacheSize(context),
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
        if (noticeData.writerIsLeader)
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
