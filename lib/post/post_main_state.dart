import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/post/post_model.dart';
import 'package:moing_flutter/model/response/get_all_posts_response.dart';
import 'package:moing_flutter/post/post_create_page.dart';
import 'package:moing_flutter/post/post_detail_page.dart';

class PostMainState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;
  final int teamId;

  AllPostData? allPostData;
  List<PostData>? filteredPostBlocks;
  List<PostData>? filteredNoticeBlocks;
  List<int>? blockUserList;

  PostMainState({
    required this.context,
    required this.teamId,
  }) {
    initState();
  }

  void initState() async {
    log('Instance "PostMainState" has been created');
    await getBlockUserList();
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

    if (blockUserList != null) {
      filteredPostBlocks = allPostData!.postBlocks
          .where((post) => !blockUserList!.contains(post.makerId))
          .toList();
      filteredNoticeBlocks = allPostData!.noticeBlocks
          .where((post) => !blockUserList!.contains(post.makerId))
          .toList();
    }
    notifyListeners();
  }

  /// 차단 유저 목록 조회 API
  Future<void> getBlockUserList() async {
    blockUserList = await apiCode.getBlockUserList();
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
      await getBlockUserList();
      await getAllPost();
    }
  }
}
