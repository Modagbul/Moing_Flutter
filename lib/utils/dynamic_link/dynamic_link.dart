import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:moing_flutter/init/init_page.dart';

class DynamicLinkService extends ChangeNotifier {
  BuildContext context;

  DynamicLinkService({required this.context}) {
    _initDynamicLinks();
  }

  Future<void> _initDynamicLinks() async {
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      print('리다이렉트 1 : ${initialLink.link.path}');
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
    required String moingTitle,
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
        appStoreId: "6472060530",
        bundleId: "com.moing.moing-team",
        minimumVersion: '0',
      ),
      navigationInfoParameters: NavigationInfoParameters(
        forcedRedirectEnabled: false,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "<$moingTitle> 소모임에서 초대장이 도착했어요.",
        description: "지금 MOING에서 소모임에 가입해보세요.",
        imageUrl: Uri.parse('https://modagbul.s3.ap-northeast-2.amazonaws.com/modak_fire.png'),
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

      Navigator.pushNamedAndRemoveUntil(
          context, InitPage.routeName, (route) => false, arguments: teamId);
    } catch (e) {
      log(e.toString());
    }
  }
}
