import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/response/get_all_posts_response.dart';
import 'package:moing_flutter/post/post_create_page.dart';
import 'package:moing_flutter/post/post_detail_page.dart';

class PostMainState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;
  final int teamId;

  AllPostData? allPostData;

  PostMainState({
    required this.context,
    required this.teamId,
  }) {
    initState();
    getAllPost();
  }

  void initState() {
    log('Instance "PostMainState" has been created');
  }

  @override
  void dispose() {
    log('Instance "PostMainState" has been removed');
    super.dispose();
  }

  void getAllPost() async {
    allPostData = await apiCode.getAllPostData(teamId: teamId);
    notifyListeners();
  }

  void navigatePostCreatePage() {
    Navigator.pushNamed(context, PostCreatePage.routeName, arguments: teamId);
  }

  void navigatePostDetailPage({required int boardId}) {
    Navigator.pushNamed(
      context,
      PostDetailPage.routeName,
      arguments: {
        'teamId': teamId,
        'boardId': boardId,
      },
    );
  }
}
