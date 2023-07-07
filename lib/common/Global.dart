import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/db/sqlite.dart';
import 'package:edrb/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
const uuid = Uuid();
const String appId = "";
const String secret = "";

class Global {
  static late SharedPreferences _preferences;

  static Profile profile = Profile();
  static SqliteDb sqliteDb = SqliteDb();

  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  static Future init() async {
    //在初始化应用之前与flutter引擎通信
    WidgetsFlutterBinding.ensureInitialized();
    //初始化缓存插件
    _preferences = await SharedPreferences.getInstance();
    String? pfInfo = _preferences.getString("profile");
    if (pfInfo != null) {
      Map<String, dynamic> map = jsonDecode(pfInfo);
      profile = Profile.fromJson(map);
    }
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
    ));
    await ScreenUtil.ensureScreenSize();
    await sqliteDb.init();
    Api.init();


    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;
    print('deviceInfo ---  $allInfo');
  }

  //持久化Profile信息
  static saveProfile() =>
      _preferences.setString("profile", jsonEncode(profile.toJson()));

  static clear(){
    profile.token = null;
    profile.status = false;
    profile.user = null;
    saveProfile();
  }

  static Map<String, dynamic> handleData(Map<String, dynamic>? data) {
    data ??= {};

    data['appid'] = appId;
    data['timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();
    data['randomStr'] = uuid.v4().toString();

    Iterable<String> keys = data.keys;
    List<String> keyList = keys.toList();
    keyList.sort((a, b) => a.compareTo(b));
    String str = '';
    Map<String, Object> param = {};
    for (var key in keyList) {
      param[key] = data[key]!;
      if (null != data[key]) {
        str = "$str$key=${data[key]}&";
      }
    }
    var bytes = utf8.encode(str + secret);
    String digest = sha256.convert(bytes).toString();
    param['signature'] = digest;
    return param;
  }
}
