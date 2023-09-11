import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:moing_flutter/home/home_screen.dart';
import 'package:moing_flutter/init/init_page.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_first.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_second.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_third.dart';
import 'package:moing_flutter/login/register_success/guide.dart';
import 'package:moing_flutter/login/register_success/welcome_page.dart';
import 'package:moing_flutter/login/sign_in/login_page.dart';
import 'package:moing_flutter/login/sign_up/sign_up_page.dart';
import 'package:moing_flutter/main/alarm/alarm.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:moing_flutter/meeting_photo.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:moing_flutter/login/category/category_page.dart';

class MoingApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(393, 852),
      useInheritedMediaQuery: true,
      builder: (BuildContext context, child) {
        return MaterialApp(
          theme: ThemeData(
            fontFamily: 'pretendard',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          navigatorKey: GetIt.I.get<GlobalKey<NavigatorState>>(),
          title: 'Moing',
          initialRoute: InitPage.routeName,
          // HomeScreen.routeName,
          routes: {
            /// StateLess 위젯만 필요하다면, 다음과 같이 작성!
            WelcomePage.routeName: (_) => WelcomePage(),

            /// StateFul 위젯이 필요하다면, 다음과 같이 작성!
            LoginPage.routeName: (context) => LoginPage.route(context),
            InitPage.routeName: (context) => InitPage.route(context),
            OnBoardingFirstPage.routeName: (context) => OnBoardingFirstPage.route(context),
            OnBoardingSecondPage.routeName: (context) => OnBoardingSecondPage.route(context),
            OnBoardingThirdPage.routeName: (context) => OnBoardingThirdPage.route(context),
            CatagoryPage.routeName: (context) => CatagoryPage.route(context),
            SignUpPage.routeName: (context) => SignUpPage.route(context),
            HomeScreen.routeName: (context) => HomeScreen.route(context),
            RegisterGuide.routeName: (context) => RegisterGuide.route(context),
            MainPage.routeName: (context) => MainPage.route(context),
            MeetingPhotoPage.routeName: (context) => MeetingPhotoPage.route(context),
            AlarmPage.routeName: (context) => AlarmPage.route(context),
            
          },
          navigatorObservers: [
            GetIt.I.get<NavigationHistoryObserver>(),
          ],
        );
      },
    );
  }
}

