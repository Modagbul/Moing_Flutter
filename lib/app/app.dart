import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:moing_flutter/board/board_main_page.dart';
import 'package:moing_flutter/board/screen/completed_mission_page.dart';
import 'package:moing_flutter/board/screen/ongoing_misson_page.dart';
import 'package:moing_flutter/board/screen/team_member_list_page.dart';
import 'package:moing_flutter/fcm/fcm_state.dart';
import 'package:moing_flutter/fix_group/fix_group_page.dart';
import 'package:moing_flutter/home/home_screen.dart';
import 'package:moing_flutter/init/init_page.dart';
import 'package:moing_flutter/login/date/sign_up_date_page.dart';
import 'package:moing_flutter/login/gender/sign_up_gender_page.dart';
import 'package:moing_flutter/login/invitate_link/welcome_team_page.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_first.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_second.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_last.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_third.dart';
import 'package:moing_flutter/login/register_success/guide.dart';
import 'package:moing_flutter/login/register_success/welcome_page.dart';
import 'package:moing_flutter/login/sign_in/login_page.dart';
import 'package:moing_flutter/login/sign_up/sign_up_page.dart';
import 'package:moing_flutter/main/alarm/alarm.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_exit_success_page.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_finish_success_page.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_finish_page.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:moing_flutter/make_group/group_create_category_page.dart';
import 'package:moing_flutter/make_group/group_create_info_page.dart';
import 'package:moing_flutter/make_group/group_create_photo_page.dart';
import 'package:moing_flutter/make_group/group_create_start_page.dart';
import 'package:moing_flutter/make_group/group_create_success_page.dart';
import 'package:moing_flutter/mission_fire/mission_fire_page.dart';
import 'package:moing_flutter/mission_prove/mission_prove_page.dart';
import 'package:moing_flutter/missions/aggregate/missions_group_page.dart';
import 'package:moing_flutter/missions/create/missions_create_page.dart';
import 'package:moing_flutter/missions/create/photo_auth_page.dart';
import 'package:moing_flutter/missions/fix/mission_fix_page.dart';
import 'package:moing_flutter/mypage/alarm_setting_page.dart';
import 'package:moing_flutter/mypage/profile_setting_page.dart';
import 'package:moing_flutter/mypage/revoke/mypage_revoke_reason_page.dart';
import 'package:moing_flutter/post/post_update_page.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:provider/provider.dart';
import '../login/onboarding_tutorial/tutorial_first.dart';
import '../login/onboarding_tutorial/tutorial_last.dart';
import '../login/onboarding_tutorial/tutorial_second.dart';
import '../login/onboarding_tutorial/tutorial_third.dart';
import '../login/onboarding_tutorial/tutorial_zero.dart';
import '../missions/aggregate/missions_all_page.dart';
import '../missions/aggregate/missions_screen.dart';
import 'package:moing_flutter/post/post_main_page.dart';
import '../missions/create/link_auth_page.dart';
import '../missions/create/skip_mission_page.dart';
import '../missions/create/text_auth_page.dart';
import '../mypage/blocked_users_page.dart';
import '../mypage/my_page_screen.dart';
import '../mypage/setting_page.dart';
import '../post/post_create_page.dart';
import '../post/post_detail_page.dart';


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
          initialRoute: InitPage.routeName,
          builder: (context, child) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => FCMState(
                    navigatorKey: GetIt.I.get(),
                    navigationHistory: GetIt.I.get(),
                  ),
                ),
              ],
              child: child,
            );
          },
          routes: {
            /// StateLess 위젯만 필요하다면, 다음과 같이 작성!
            WelcomePage.routeName: (_) => const WelcomePage(),
            /// StateFul 위젯이 필요하다면, 다음과 같이 작성!
            LoginPage.routeName: (context) => LoginPage.route(context),
            InvitationWelcomePage.routeName: (context) => InvitationWelcomePage.route(context),
            InitPage.routeName: (context) => InitPage.route(context),
            OnBoardingFirstPage.routeName: (context) => OnBoardingFirstPage.route(context),
            OnBoardingSecondPage.routeName: (context) => OnBoardingSecondPage.route(context),
            OnBoardingThirdPage.routeName: (context) => OnBoardingThirdPage.route(context),
            OnBoardingLastPage.routeName: (context) => OnBoardingLastPage.route(context),

            TutorialZero.routeName: (context) => TutorialZero.route(context),
            TutorialFirst.routeName: (context) => TutorialFirst.route(context),
            TutorialSecond.routeName: (context) => TutorialSecond.route(context),
            TutorialThird.routeName: (context) => TutorialThird.route(context),
            TutorialLast.routeName: (context) => TutorialLast.route(context),

            SignUpPage.routeName: (context) => SignUpPage.route(context),
            SignUpGenderPage.routeName: (context) => SignUpGenderPage.route(context),
            SignUpDatePage.routeName: (context) => SignUpDatePage.route(context),
            HomeScreen.routeName: (context) => HomeScreen.route(context),
            RegisterGuide.routeName: (context) => RegisterGuide.route(context),
            MainPage.routeName: (context) => MainPage.route(context),
            MissionsScreen.routeName: (context) => MissionsScreen.route(context),
            MissionsAllPage.routeName: (context) => MissionsAllPage.route(context),
            MissionsGroupPage.routeName: (context) => MissionsGroupPage.route(context),
            MissionsCreatePage.routeName: (context) => MissionsCreatePage.route(context),
            MissionFixPage.routeName: (context) => MissionFixPage.route(context),
            MissionFirePage.routeName: (context) => MissionFirePage.route(context),
            MissionProvePage.routeName: (context) => MissionProvePage.route(context),
            TextAuthPage.routeName:(context) => TextAuthPage.route(context),
            LinkAuthPage.routeName:(context) => LinkAuthPage.route(context),
            PhotoAuthPage.routeName:(context) => PhotoAuthPage.route(context),
            SkipMissionPage.routeName:(context) => SkipMissionPage.route(context),

            AlarmPage.routeName: (context) => AlarmPage.route(context),
            BoardMainPage.routeName: (context) => BoardMainPage.route(context),
            CompletedMissionPage.routeName: (context) => CompletedMissionPage.route(context),
            OngoingMissionPage.routeName: (context) => OngoingMissionPage.route(context),
            GroupCreateStartPage.routeName: (context) => GroupCreateStartPage.route(context),
            GroupCreateCategoryPage.routeName: (context) => GroupCreateCategoryPage.route(context),
            GroupCreateInfoPage.routeName: (context) => GroupCreateInfoPage.route(context),
            GroupCreatePhotoPage.routeName: (context) => GroupCreatePhotoPage.route(context),
            GroupCreateSuccessPage.routeName: (context) => GroupCreateSuccessPage.route(context),
            GroupFinishPage.routeName:(context) => GroupFinishPage.route(context),
            GroupFinishSuccessPage.routeName:(context) => GroupFinishSuccessPage.route(context),
            GroupExitApplyPage.routeName:(context) => GroupExitApplyPage.route(context),
            FixGroupPage.routeName:(context) => FixGroupPage.route(context),

            PostMainPage.routeName:(context) => PostMainPage.route(context),
            PostDetailPage.routeName:(context) => PostDetailPage.route(context),
            PostCreatePage.routeName:(context) => PostCreatePage.route(context),
            PostUpdatePage.routeName:(context) => PostUpdatePage.route(context),

            ProfileSettingPage.routeName:(context) => ProfileSettingPage.route(context),

            SettingPage.routeName:(context) => SettingPage.route(context),
            AlarmSettingPage.routeName:(context) => AlarmSettingPage.route(context),
            BlockedUsersPage.routeName:(context) => BlockedUsersPage.route(context),

            MyPageScreen.routeName:(context) => MyPageScreen.route(context: context),
            MyPageRevokeReasonPage.routeName:(context) => MyPageRevokeReasonPage.route(context),

            TeamMemberListPage.routeName:(context) => TeamMemberListPage.route(context),

          },
          navigatorObservers: [
            GetIt.I.get<NavigationHistoryObserver>(),
          ],
        );
      },
    );
  }
}

