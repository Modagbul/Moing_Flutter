import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/post/post_detail_model.dart';
import 'package:moing_flutter/model/request/create_comment_request.dart';
import 'package:moing_flutter/model/response/get_all_comments_response.dart';

class PostDetailState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;
  final TextEditingController commentController = TextEditingController();

  final int boardId;
  final int teamId;

  PostDetailData? postData;
  AllCommentData? allCommentData;

  PostDetailState({
    required this.context,
    required this.teamId,
    required this.boardId,
  }) {
    initState();
    getDetailPostData();
    getAllCommentData();
  }

  void initState() {
    log('Instance "PostDetailState" has been created');
  }

  @override
  void dispose() {
    log('Instance "PostDetailState" has been removed');
    super.dispose();
  }

  void clearNameTextField() {
    commentController.clear();
  }

  void updateTextField() {
    notifyListeners();
  }

  void getDetailPostData() async {
    postData =
        await apiCode.getDetailPostData(teamId: teamId, boardId: boardId);
    notifyListeners();
  }

  void getAllCommentData() async {
    allCommentData =
        await apiCode.getAllCommentData(teamId: teamId, boardId: boardId);
    notifyListeners();
  }

  void postCreateComment() {
    apiCode.postCreateComment(
      teamId: teamId,
      boardId: boardId,
      createCommentData: CreateCommentData(
        content: commentController.value.text,
      ),
    );
    clearNameTextField();
    notifyListeners();
  }

  void deleteComment(){

  }
}
