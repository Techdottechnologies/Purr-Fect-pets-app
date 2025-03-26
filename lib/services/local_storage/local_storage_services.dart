// Project: 	   muutsch
// File:    	   local_storage_services
// Path:    	   lib/services/local_storage_services/local_storage_services.dart
// Author:       Ali Akbar
// Date:        09-06-24 11:54:38 -- Sunday
// Description:

import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants/constants.dart';

class LocalStorageServices {
  static final LocalStorageServices _instance =
      LocalStorageServices._internal();
  SharedPreferences? pref;

  LocalStorageServices._internal() {
    initial();
  }

  Future<void> initial() async {
    pref = await SharedPreferences.getInstance();
  }

  factory LocalStorageServices() => _instance;

  Future<void> saveFirstLogin() async {
    pref!.setBool("FIRST_TIME_LOGIN", true);
  }

  Future<bool> getFirstLogin() async {
    return pref?.getBool("FIRST_TIME_LOGIN") ?? false;
  }

  Future<void> savedPushNotificationIdentify(String topic) async {
    final topics = await getPushNotificationIdentifies();
    topics.add(topic);
    topics.toSet().toList();
    pref?.setStringList("PUSH_NOTIFICATION_IDS", topics);
  }

  Future<void> clearAllPushNotificationTopics() async {
    pref?.setStringList("PUSH_NOTIFICATION_IDS", []);
  }

  Future<List<String>> getPushNotificationIdentifies() async {
    return pref!.getStringList("PUSH_NOTIFICATION_IDS") ?? [];
  }

  Future<List<String>> getMessageIds() async {
    return pref?.getStringList(SHARED_PREFERENCES_MESSAGE_IDS) ?? [];
  }

  Future<void> saveMessageIds({required List<String> ids}) async {
    final List<String> oldIds = await getMessageIds();
    oldIds.addAll(ids);
    pref?.setStringList(SHARED_PREFERENCES_MESSAGE_IDS, oldIds);
  }
}
