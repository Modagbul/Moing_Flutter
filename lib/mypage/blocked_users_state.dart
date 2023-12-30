import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../const/color/colors.dart';
import '../const/style/text.dart';
import '../model/api_code/api_code.dart';
import '../model/api_generic.dart';
import '../model/api_response.dart';
import '../model/response/blocked_member_response.dart';
import '../utils/toast/toast_message.dart';

class BlockedUsersState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final APICall call = APICall();

  final BuildContext context;

  String apiUrl = '';

  List<BlockedMemberInfo>? blockedMemberStatus;

  FToast fToast = FToast();
  final ToastMessage toastMessage = ToastMessage();

  BlockedUsersState({
    required this.context,
  }) {
    initState();
  }

  void initState() async {
    await getBlockedMemberStatus();
    log('Instance "BlockedUsersState" has been created');
  }

  @override
  void dispose() {
    log('Instance "BlockedUsersState" has been removed');
    super.dispose();
  }

  Future<void> getBlockedMemberStatus() async {
    try {
      var result = await apiCode.getBlockedMemberStatus();
      if (result != null) {
        blockedMemberStatus = result;
      }
      notifyListeners();
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  void reloadBlockedMemberStatus() async {
    await getBlockedMemberStatus();
    notifyListeners();
  }

  /// 차단 해제 API
  Future<void> unblockUser({required int targetId, required String nickName}) async {
    apiUrl = '${dotenv.env['MOING_API']}/api/block/$targetId';

    try {
      ApiResponse<int> apiResponse = await call.makeRequest<int>(
        url: apiUrl,
        method: 'DELETE',
        fromJson: (dataJson) => dataJson as int,
      );

      if (apiResponse.isSuccess) {
        print('${apiResponse.data}번 사용자의 차단 해제가 완료되었습니다.');
        _showToastMessage(
          message: '$nickName님이 차단 해제되었어요.',
          positionedToastBuilder: (context, child) => Positioned(
            top: 110.0,
            left: 0.0,
            right: 0,
            child: child,
          ),
        );
        reloadBlockedMemberStatus(); // 차단 목록 새로고침
      } else {
        print('unblockUser is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('사용자 차단 해제 실패: $e');
    }
  }

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
