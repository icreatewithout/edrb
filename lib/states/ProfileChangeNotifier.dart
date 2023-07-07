import 'package:edrb/common/Global.dart';
import 'package:edrb/models/profile.dart';
import 'package:flutter/material.dart';


class ProfileChangeNotifier extends ChangeNotifier {
  Profile get profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile(); //保存profile变更
    super.notifyListeners(); //通知依赖的widget更新
  }
}
