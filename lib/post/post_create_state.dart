import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/request/create_post_request.dart';

import '../const/color/colors.dart';
import '../const/style/text.dart';

class PostCreateState extends ChangeNotifier {
  ApiCode apiCode = ApiCode();

  final FToast fToast = FToast();

  final BuildContext context;
  final int teamId;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  bool isCheckedNotice = false;
  bool isButtonEnabled = false;

  bool _isCreatePostInProgress = false;

  PostCreateState({
    required this.teamId,
    required this.context,
  }) {
    initState();
  }

  void initState() {
    fToast.init(context);
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

  Future<void> requestCreatePost() async {
    if (_isCreatePostInProgress) return;

    _isCreatePostInProgress = true;

    await apiCode.postCreatePostOrNotice(
      teamId: teamId,
      createPostData: CreatePostData(
        title: titleController.value.text,
        content: contentController.value.text,
        isNotice: isCheckedNotice,
      ),
    );
    _isCreatePostInProgress = false;
    notifyListeners();
    Navigator.pop(context, true);

    String warningText = '${isCheckedNotice ? '공지가' : '게시글이'} 등록되었어요.';

    if (warningText.isNotEmpty) {
      fToast.showToast(
          child: Material(
            type: MaterialType.transparency,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 51,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        warningText,
                        style: bodyTextStyle.copyWith(
                          color: grayScaleGrey700,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          toastDuration: const Duration(milliseconds: 3000),
          positionedToastBuilder: (context, child) {
            return Positioned(
              top: 114.0,
              left: 0.0,
              right: 0,
              child: child,
            );
          });
    }
  }
}
