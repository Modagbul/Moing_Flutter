import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/request/create_post_request.dart';

class PostCreateState extends ChangeNotifier {
  ApiCode apiCode = ApiCode();

  final BuildContext context;
  final int teamId;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  bool isCheckedNotice = false;
  bool isButtonEnabled = false;

  PostCreateState({
    required this.teamId,
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "PostCreateState" has been created');
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    log('Instance "PostCreateState" has been removed');
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

  void requestCreatePost() async {
    await apiCode.postCreatePostOrNotice(
      teamId: teamId,
      createPostData: CreatePostData(
        title: titleController.value.text,
        content: contentController.value.text,
        isNotice: isCheckedNotice,
      ),
    );

     Navigator.pop(context, true);
  }
}
