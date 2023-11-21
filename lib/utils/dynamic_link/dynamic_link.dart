import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:moing_flutter/login/sign_in/login_page.dart';

class DynamicLinkService extends ChangeNotifier {
  BuildContext context;

  DynamicLinkService({required this.context}) {
    _initDynamicLinks();
  }

  Future<void> _initDynamicLinks() async {
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      print('리다이렉트 1');
      redirect(initialLink);
    }

    FirebaseDynamicLinks.instance.onLink.listen(
          (PendingDynamicLinkData? pendingDynamicLinkData) async {
        if (pendingDynamicLinkData != null) {
          print('리다이렉트 2');
          redirect(pendingDynamicLinkData);
        }
      },
      onError: (e) async {
        print(e.message);
      },
    );
  }

  Future<String> getShortLink({
    required String route,
  }) async {
    String dynamicLinkPrefix = 'https://moing.page.link';
    final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: dynamicLinkPrefix,
      link: Uri.parse('https://moing.page.link/$route'),
      androidParameters: AndroidParameters(
        packageName: "com.moing.moing_team",
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        appStoreId: "6444061302",
        bundleId: "com.moing.moing-team",
        minimumVersion: '0',
      ),
      navigationInfoParameters: NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
    );
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    return dynamicLink.shortUrl.toString();
  }

  Future<void> redirect(PendingDynamicLinkData dynamicLinkData) async {
    try {
      String link = dynamicLinkData.link.path;
      print('link성공! : $link');
      String teamId = link.replaceAll('/teamId=', '');
      print('teamId : $teamId');

      Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, (route) => false, arguments: teamId);
      // switch (link) {
      //   case "/counselor":
      //     final UserRepository userRepository = UserRepository();
      //     String? uniqueIdString = dynamicLinkData.link.queryParameters["uniqueId"];
      //     if (uniqueIdString == null) throw "잘못된 요청입니다";
      //     User? user = await userRepository.getUserWithUniqueId(uniqueId: int.parse(uniqueIdString));
      //     if (user == null) throw "사용자를 찾을 수 없습니다";
      //     if (!(user.isCounselor ?? false)) throw "상담사를 찾을 수 없습니다";
      //     if (!(user.isCounselorCertificated ?? false)) throw "승인이 필요한 상담사입니다";
      //
      //     Navigator.pushNamed(
      //       context,
      //       CounselorDetailPage.routeName,
      //       arguments: CounselorDetailArgument(
      //         counselorId: user.id!,
      //       ),
      //     );
      //     break;
      //   default:
      //     final Uri deepLink = dynamicLinkData.link;
      //     Navigator.pushNamed(context, deepLink.path);
      //     break;
      // }
    } catch (e) {
      log(e.toString());
    }
  }
}
