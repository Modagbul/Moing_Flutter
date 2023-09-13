import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:moing_flutter/board/board_main_page.dart';
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
import 'package:moing_flutter/make_group/group_create_category_page.dart';
import 'package:moing_flutter/make_group/group_create_info_page.dart';
import 'package:moing_flutter/make_group/group_create_photo_page.dart';
import 'package:moing_flutter/make_group/group_create_start_page.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';


class MoingApp extends StatelessWidget {
  const MoingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      useInheritedMediaQuery: true,
      builder: (BuildContext context, child) {
        return MaterialApp(
          theme: ThemeData(
            fontFamily: 'pretendard',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          navigatorKey: GetIt.I.get<GlobalKey<NavigatorState>>(),
          title: 'Moing',
          initialRoute: LoginPage.routeName,
          routes: {
            /// StateLess 위젯만 필요하다면, 다음과 같이 작성!
            WelcomePage.routeName: (_) => const WelcomePage(),

            /// StateFul 위젯이 필요하다면, 다음과 같이 작성!
            LoginPage.routeName: (context) => LoginPage.route(context),
            InitPage.routeName: (context) => InitPage.route(context),
            OnBoardingFirstPage.routeName: (context) => OnBoardingFirstPage.route(context),
            OnBoardingSecondPage.routeName: (context) => OnBoardingSecondPage.route(context),
            OnBoardingThirdPage.routeName: (context) => OnBoardingThirdPage.route(context),
            SignUpPage.routeName: (context) => SignUpPage.route(context),
            HomeScreen.routeName: (context) => HomeScreen.route(context),
            RegisterGuide.routeName: (context) => RegisterGuide.route(context),
            MainPage.routeName: (context) => MainPage.route(context),

            AlarmPage.routeName: (context) => AlarmPage.route(context),
            BoardMainPage.routeName: (context) => BoardMainPage.route(context),

            GroupCreateStartPage.routeName: (context) => GroupCreateStartPage.route(context),
            GroupCreateCategoryPage.routeName: (context) => GroupCreateCategoryPage.route(context),
            GroupCreateInfoPage.routeName: (context) => GroupCreateInfoPage.route(context),
            GroupCreatePhotoPage.routeName: (context) => GroupCreatePhotoPage.route(context),

            BoardMainPage.routeName: (context) => BoardMainPage.route(context),
          },
          navigatorObservers: [
            GetIt.I.get<NavigationHistoryObserver>(),
          ],
        );
      },
    );
  }
}
