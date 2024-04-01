import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AmplitudeConfig {
  static late Amplitude analytics = Amplitude.getInstance(instanceName: "team-moing");

  Future<void> init() async {
    String apiKey = dotenv.env['AMPLITUDE_API_KEY']!;
    analytics.init(apiKey);
    // Enable COPPA privacy guard. This is useful when you choose not to report sensitive user information.
    analytics.enableCoppaControl();

    // Set user Id
    analytics.setUserId("IAMHYUNSEOK");

    // Turn on automatic session events
    analytics.trackingSessionEvents(true);

    // // Log an event
    // analytics.logEvent('MyApp startup',
    //     eventProperties: {'friend_num': 10, 'is_heavy_user': true});

    // // Identify
    // final Identify identify1 = Identify()
    //   ..set('identify_test',
    //       'identify sent at ${DateTime.now().millisecondsSinceEpoch}')
    //   ..add('identify_count', 1);
    // analytics.identify(identify1);

    // Set group
    // analytics.setGroup('orgId', 15);

    // // Group identify
    // final Identify identify2 = Identify()..set('identify_count', 1);
    // analytics.groupIdentify('orgId', '15', identify2);
  }
}