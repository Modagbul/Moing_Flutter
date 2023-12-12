import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/post/post_detail_model.dart';
import 'package:moing_flutter/model/request/create_comment_request.dart';
import 'package:moing_flutter/model/response/get_all_comments_response.dart';
import 'package:moing_flutter/post/post_update_page.dart';

import '../const/style/text.dart';

class PostDetailState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;
  final TextEditingController commentController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final int boardId;
  final int teamId;

  PostDetailData? postData;
  AllCommentData? allCommentData;

  final FToast fToast = FToast();

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
    fToast.init(context);
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

  // 화면 최하단으로 스크롤
  void scrollToBottom() {
    scrollController.jumpTo(
      scrollController.position.maxScrollExtent,
    );
  }

  void getDetailPostData() async {
    postData =
        await apiCode.getDetailPostData(teamId: teamId, boardId: boardId);
    notifyListeners();
  }

  Future<void> getAllCommentData() async {
    allCommentData =
        await apiCode.getAllCommentData(teamId: teamId, boardId: boardId);
    notifyListeners();
  }

  Future<void> postCreateComment() async {
    await apiCode.postCreateComment(
      teamId: teamId,
      boardId: boardId,
      createCommentData: CreateCommentData(
        content: commentController.value.text,
      ),
    );
    await getAllCommentData();
    clearNameTextField();
    FocusScope.of(context).unfocus(); // 키보드 닫힘
    scrollToBottom(); // 화면 아래로 이동
    notifyListeners();
  }

  void deleteComment({required int boardCommentId}) {
    apiCode.deleteComment(
        teamId: teamId, boardId: boardId, boardCommentId: boardCommentId);
    allCommentData?.commentBlocks.removeWhere((commentBlock) {
      return commentBlock.boardCommentId == boardCommentId;
    });
    notifyListeners();

    String warningText = '댓글이 삭제되었어요.';

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
              bottom: 136.0,
              left: 0.0,
              right: 0,
              child: child,
            );
          });
    }
  }

  void deletePost() async {
    await apiCode.deletePost(teamId: teamId, boardId: boardId);
    notifyListeners();
    Navigator.pop(context);
    Navigator.pop(context, true);

    String warningText = '게시글이 삭제되었어요.';

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

  void navigatePostUpdatePage() async {
    final result = await Navigator.pushNamed(
      context,
      PostUpdatePage.routeName,
      arguments: {
        'teamId': teamId,
        'boardId': boardId,
        'postData': postData,
      },
    );

    if (result as bool) {
      getDetailPostData();
    }

    Navigator.of(context).pop();

    String warningText = '게시글이 수정되었어요.';

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
              bottom: 136.0,
              left: 0.0,
              right: 0,
              child: child,
            );
          });
    }
  }

  void reportPost() async {
    final bool? isSuccess = await apiCode.postReportPost(boardId: boardId);

    if (isSuccess != null && isSuccess) {
      fToast.showToast(
          child: Material(
            type: MaterialType.transparency,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 51,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '신고가 완료되었어요',
                        style: TextStyle(
                          color: grayBlack8,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          toastDuration: const Duration(milliseconds: 3000),
          positionedToastBuilder: (context, child) {
            return Positioned(
              bottom: 120.0,
              left: 0.0,
              right: 0,
              child: child,
            );
          });

      Navigator.of(context).pop();
    }
  }
}
