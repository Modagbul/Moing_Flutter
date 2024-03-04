import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/post/post_model.dart';
import 'package:moing_flutter/model/response/get_all_posts_response.dart';
import 'package:moing_flutter/post/post_create_page.dart';
import 'package:moing_flutter/post/post_detail_page.dart';
import 'package:moing_flutter/utils/global/api_code/api_code.dart';

class PostMainState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;
  final int teamId;

  AllPostData? allPostData;
  List<PostData>? postBlocks;
  List<PostData>? noticeBlocks;

  PostMainState({
    required this.context,
    required this.teamId,
  }) {
    initState();
  }

  void initState() async {
    log('Instance "PostMainState" has been created');
    await getAllPost();
  }

  @override
  void dispose() {
    log('Instance "PostMainState" has been removed');
    super.dispose();
  }

  /// 모든 게시물/공지 조회 API
  Future<void> getAllPost() async {
    allPostData = await apiCode.getAllPostData(teamId: teamId);

    if (allPostData == null) return;

    postBlocks = allPostData!.postBlocks;
    noticeBlocks = allPostData!.noticeBlocks;

    notifyListeners();
  }

  void navigatePostCreatePage() async {
    final result = await Navigator.pushNamed(
      context,
      PostCreatePage.routeName,
      arguments: teamId,
    );

    if (result as bool) {
      getAllPost();
    }
  }

  void navigatePostDetailPage({required int boardId}) async {
    final result = await Navigator.pushNamed(
      context,
      PostDetailPage.routeName,
      arguments: {
        'teamId': teamId,
        'boardId': boardId,
      },
    );

    if (result as bool) {
      await getAllPost();
    }
  }
}
