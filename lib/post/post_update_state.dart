import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/post/post_detail_model.dart';
import 'package:moing_flutter/model/request/create_post_request.dart';

class PostUpdateState extends ChangeNotifier {
  ApiCode apiCode = ApiCode();

  final BuildContext context;
  final int teamId;
  final int boardId;
  final PostDetailData postData;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  bool isCheckedNotice = false;
  bool isButtonEnabled = false;

  bool isRequestUpdatePostInProgress = false;

  PostUpdateState({
    required this.teamId,
    required this.boardId,
    required this.context,
    required this.postData,
  }) {
    initState();
  }

  void initState() {
    titleController.text = postData.title;
    contentController.text = postData.content;
    log('Instance "PostUpdateState" has been created');
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    log('Instance "PostUpdateState" has been removed');
    super.dispose();
  }

  void clearTitleTextField() {
    titleController.clear();
    isButtonEnabled = false;
    notifyListeners();
  }

  void toggleCheckedNotice() {
    isCheckedNotice = !isCheckedNotice;
    notifyListeners();
  }

  void updateTextField() {
    if (titleController.value.text.isNotEmpty &&
        contentController.value.text.isNotEmpty) {
      isButtonEnabled = true;
    } else {
      isButtonEnabled = false;
    }
    notifyListeners();
  }

  void requestUpdatePost() async {
    if(isRequestUpdatePostInProgress) return;

    isRequestUpdatePostInProgress = true;
    await apiCode.putUpdatePostOrNotice(
      teamId: teamId,
      boardId: boardId,
      createPostData: CreatePostData(
        title: titleController.value.text,
        content: contentController.value.text,
        isNotice: isCheckedNotice,
      ),
    );
    isRequestUpdatePostInProgress = false;
    Navigator.pop(context, true);
  }
}
