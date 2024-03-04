import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/make_group/component/warning_dialog.dart';
import 'package:moing_flutter/model/comment/comment_model.dart';
import 'package:moing_flutter/model/post/post_detail_model.dart';
import 'package:moing_flutter/model/request/create_comment_request.dart';
import 'package:moing_flutter/model/comment/get_all_comments_response.dart';
import 'package:moing_flutter/post/post_update_page.dart';
import 'package:moing_flutter/repository/comment_repository.dart';
import 'package:moing_flutter/utils/global/api_code/api_code.dart';

import '../const/style/text.dart';

class PostDetailState extends ChangeNotifier {
  late final CommentRepository _commentRepository;

  final ApiCode apiCode = ApiCode();
  final BuildContext context;
  final TextEditingController commentController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final int boardId;
  final int teamId;

  PostDetailData? postData;
  AllCommentData? allCommentData;
  List<CommentData>? commentBlocks;

  final FToast fToast = FToast();

  bool _isCreateCommentInProgress = false;
  bool _isDeleteCommentInProgress = false;
  bool _isReportPostInProgress = false;
  bool _isBlockUserInProgress = false;

  PostDetailState({
    required this.context,
    required this.teamId,
    required this.boardId,
  }) {
    initState();
  }

  void initState() async {
    fToast.init(context);
    _commentRepository = CommentRepository();
    await getDetailPostData();
    getAllCommentData();
    log('Instance "PostDetailState" has been created');
  }

  @override
  void dispose() {
    log('Instance "PostDetailState" has been removed');
    super.dispose();
  }

  /// 게시물 정보 호출 API
  Future<void> getDetailPostData() async {
    postData =
        await apiCode.getDetailPostData(teamId: teamId, boardId: boardId);
    notifyListeners();
  }

  /// 댓글 정보 호출 API
  Future<void> getAllCommentData() async {
    allCommentData = await _commentRepository.getAllCommentData(teamId: teamId, boardId: boardId);

    if (allCommentData == null) return;

    commentBlocks = allCommentData!.commentBlocks;
    notifyListeners();
  }

  /// 댓글 생성 API
  Future<void> postCreateComment() async {
    if (_isCreateCommentInProgress) return;

    _isCreateCommentInProgress = true;
    final bool? isSuccess = await apiCode.postCreateComment(
      teamId: teamId,
      boardId: boardId,
      createCommentData: CreateCommentData(
        content: commentController.value.text,
      ),
    );

    if (isSuccess != null && isSuccess) {
      await getAllCommentData();
      clearCommentTextField();
      FocusScope.of(context).unfocus();
      scrollToBottom();
      notifyListeners();
    }

    _isCreateCommentInProgress = false;
  }

  /// 댓글 삭제 API
  Future<void> deleteComment({required int boardCommentId}) async {
    if (_isDeleteCommentInProgress) return;

    _isDeleteCommentInProgress = true;

    final bool? isSuccess = await apiCode.deleteComment(
      teamId: teamId,
      boardId: boardId,
      boardCommentId: boardCommentId,
    );

    if (isSuccess != null && isSuccess) {
      await getAllCommentData();
      notifyListeners();
      _showToastMessage(
        message: '댓글이 삭제되었어요.',
        positionedToastBuilder: (context, child) {
          return Positioned(
            bottom: 136.0,
            left: 0.0,
            right: 0,
            child: child,
          );
        },
      );
    }

    _isDeleteCommentInProgress = false;
  }

  /// 게시글 삭제 API
  Future<void> deletePost() async {
    await apiCode.deletePost(teamId: teamId, boardId: boardId);
    notifyListeners();
    Navigator.pop(context);
    Navigator.pop(context, true);

    _showToastMessage(
      message: '게시글이 삭제되었어요.',
      positionedToastBuilder: (context, child) {
        return Positioned(
          top: 116.0,
          left: 0.0,
          right: 0,
          child: child,
        );
      },
    );
  }

  /// 게시물 수정 페이지 이동 (게시물 수정 API)
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
      Navigator.of(context).pop(true);
      await getDetailPostData();
      _showToastMessage(
        message: '게시글이 수정되었어요.',
        positionedToastBuilder: (context, child) {
          return Positioned(
            bottom: 136.0,
            left: 0.0,
            right: 0,
            child: child,
          );
        },
      );
    }
  }

  /// 게시물/댓글 작성 유저 신고 API
  void reportPost({required String reportType, required int targetId}) async {
    if (_isReportPostInProgress) return;

    _isReportPostInProgress = true;

    final bool? isSuccess = await apiCode.postReportPost(
      reportType: reportType,
      targetId: targetId,
    );

    if (isSuccess != null && isSuccess) {
      if (reportType == 'BOARD') {
        await getDetailPostData();
        Navigator.of(context).pop(true);
      }

      if (reportType == 'COMMENT') {
        await getAllCommentData();
        notifyListeners();
      }
      _showToastMessage(
        message: '신고가 접수되었어요.\n 24시간 이내에 확인 후 조치할게요.',
        positionedToastBuilder: (context, child) {
          return Positioned(
            bottom: 120.0,
            left: 0.0,
            right: 0,
            child: child,
          );
        },
      );
    }
    _isReportPostInProgress = false;
  }

  /// 작성 유저 차단 API
  Future<void> postBlockUser() async {
    if (postData == null) return;
    if (_isBlockUserInProgress) return;

    _isBlockUserInProgress = true;

    final bool? isSuccess =
        await apiCode.postBlockUser(targetId: postData!.makerId);

    if (isSuccess == true) {
      _showToastMessage(
        message: '차단이 완료되었어요.',
        positionedToastBuilder: (context, child) {
          return Positioned(
            bottom: 120.0,
            left: 0.0,
            right: 0,
            child: child,
          );
        },
      );
    }

    notifyListeners();

    _isBlockUserInProgress = false;
  }

  // 작성 유저 차단 바텀 모달
  Future<void> showBlockUserModal({
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WarningDialog(
              title: '${postData?.writerNickName ?? '작성자'}님을 차단하시겠어요?',
              content:
                  '차단한 이용자의 콘텐츠가 더 이상 표시되지 않아요\n[설정>차단 멤버 관리]에서 언제든 해제할 수 있어요',
              leftText: '취소하기',
              onCanceled: () {
                Navigator.of(ctx).pop(true);
              },
              rightText: '차단하기',
              onConfirm: () {
                Navigator.of(ctx).pop(true);
                Navigator.of(ctx).pop(true);
                postBlockUser();
              },
            ),
          ],
        );
      },
    );
  }

  // 댓글 신고 바텀 모달
  Future<void> showReportCommentModal({
    required BuildContext context,
    required int targetId,
    required String reportType,
  }) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WarningDialog(
              title: '이 댓글을 신고하시겠어요?',
              content: '신고한 댓글은 모든 모임원들에게 숨겨져요',
              leftText: '취소하기',
              onCanceled: () {
                Navigator.of(ctx).pop(true);
              },
              rightText: '신고하기',
              onConfirm: () {
                Navigator.of(ctx).pop(true);
                reportPost(targetId: targetId, reportType: reportType);
              },
            ),
          ],
        );
      },
    );
  }

  // 게시글 신고 바텀 모달
  Future<void> showReportPostModal({
    required BuildContext context,
    required int targetId,
    required String reportType,
  }) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WarningDialog(
              title: '이 게시글을 신고하시겠어요?',
              content: '신고한 게시글은 모든 모임원들에게 숨겨져요',
              leftText: '취소하기',
              onCanceled: () {
                Navigator.of(ctx).pop(true);
              },
              rightText: '신고하기',
              onConfirm: () {
                Navigator.of(ctx).pop(true);
                Navigator.of(ctx).pop(true);
                reportPost(targetId: targetId, reportType: reportType);
              },
            ),
          ],
        );
      },
    );
  }

  // 댓글 입력창 초기화
  void clearCommentTextField() => commentController.clear();

  // 댓글 입력 감지
  void updateTextField() => notifyListeners();

  // 화면 최하단으로 스크롤
  void scrollToBottom() =>
      scrollController.jumpTo(scrollController.position.maxScrollExtent);

  // 탑 토스트 메세지
  void _showToastMessage({
    required String message,
    required PositionedToastBuilder positionedToastBuilder,
  }) {
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
                    message,
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
      positionedToastBuilder: positionedToastBuilder,
    );
  }
}
