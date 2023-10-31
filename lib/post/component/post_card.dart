import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';

class PostCard extends StatelessWidget {
  final String nickName;
  final String title;
  final String content;
  final int commentNum;

  const PostCard({
    super.key,
    required this.commentNum,
    required this.nickName,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _renderNoticeCardHeader(nickName: nickName),
          const SizedBox(height: 8.0),
          _renderNoticeCardBody(title: title, content: content),
          const SizedBox(height: 12.0),
          _renderNoticeCardFooter(commentNum: commentNum),
        ],
      ),
    );
  }

  Widget _renderNoticeCardHeader({required String nickName}) {
    return Row(
      children: [
        Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: grayScaleGrey500,
            borderRadius: BorderRadius.circular(50),
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
        Image.asset(
          'asset/image/icon_crown.png',
          width: 14.0,
          height: 14.0,
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert, size: 24.0),
          color: grayScaleGrey400,
        )
      ],
    );
  }

  Widget _renderNoticeCardBody(
      {required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: grayScaleWhite,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          content,
          style: const TextStyle(
            color: grayScaleGrey400,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _renderNoticeCardFooter({required int commentNum}) {
    return Row(
      children: [
        Image.asset(
          'asset/image/icon_message.png',
          width: 14.0,
          height: 14.0,
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
