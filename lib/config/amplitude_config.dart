import 'dart:developer';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:amplitude_flutter/identify.dart';

class AmplitudeConfig {
  static Amplitude analytics = Amplitude.getInstance(instanceName: "team-moing");

  Future<void> init() async {
    String apiKey = dotenv.env['AMPLITUDE_API_KEY']!;
    analytics.init(apiKey);
    // Enable COPPA privacy guard. This is useful when you choose not to report sensitive user information.
    analytics.enableCoppaControl();

    // Turn on automatic session events
    analytics.trackingSessionEvents(true);
    // // Log an event
    // analytics.logEvent('MyApp startup',
    //     eventProperties: {'friend_num': 10, 'is_heavy_user': true});

    // Set group
    // analytics.setGroup('orgId', 15);

    // // Group identify
    // final Identify identify2 = Identify()..set('identify_count', 1);
    // analytics.groupIdentify('orgId', '15', identify2);
  }

  void setUserInfo({required String gender, required int age, required String ageGroup, required String nickname}) {
    analytics.setUserId(nickname);
    final Identify identify = Identify()
      ..set('gender', gender)
      ..set('age', age)
      ..set('age_group', ageGroup);
    analytics.identify(identify);
  }
}