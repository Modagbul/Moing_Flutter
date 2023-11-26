import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesInfo {
  // SharedPreference 값 저장
  Future<void> savePreferencesData(String key, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }

  // SharedPreference 값 불러오기
  Future<String?> loadPreferencesData(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getString(key);
  }

  // void removePreferencesData(String key) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   await pref.remove(key);
  // }

  // SharedPreference 값 삭제
  Future<void> removePreferencesData(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove(key);
  }

}