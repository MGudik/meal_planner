import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/user.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User());

  void setUser(User user) async {
    if (user.name == null) {
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', user.name!);
    state = user;
  }

  void loadUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');
    final String? userID = await _getId();
    final user = User(id: userID, name: username);
    print(userID);

    state = user;
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    } else if (Platform.isLinux) {
      var linuxDeviceInfo = await deviceInfo.linuxInfo;
      return linuxDeviceInfo.machineId;
    }
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier());
