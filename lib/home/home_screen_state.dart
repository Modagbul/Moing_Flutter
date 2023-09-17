import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:moing_flutter/main/alarm/alarm.dart';
import 'package:moing_flutter/make_group/group_create_start_page.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/response/group_team.dart';

class HomeScreenState extends ChangeNotifier {
  final BuildContext context;
  Future<ApiResponse<TeamData>>? futureData;

  // 알림 여부
  bool isNotification = false;

  HomeScreenState({required this.context}) {
    log('Instance "HomeScreenState" has been created');
    loadTeamData();
  }

  /// API 데이터 로딩
  void loadTeamData() {
    futureData = fetchApiData('${dotenv.env['MOING_API']}/api/team');
    notifyListeners();
  }

  Future<ApiResponse<TeamData>> fetchApiData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return ApiResponse<TeamData>.fromJson(
          json.decode(response.body), TeamData.fromJson);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void alarmPressed() {
    Navigator.of(context).pushNamed(
      AlarmPage.routeName,
    );
  }

  void makeGroupPressed() {
    Navigator.of(context).pushNamed(
      GroupCreateStartPage.routeName,
    );
  }
}
