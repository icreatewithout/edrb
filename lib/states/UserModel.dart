import 'package:edrb/models/user_vo.dart';
import 'package:edrb/states/ProfileChangeNotifier.dart';

class UserModel extends ProfileChangeNotifier {
  UserVo? get user => profile.user;

  //APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => profile.status;

  set user(UserVo? user) {
    profile.status = true;
    profile.user = user;
    notifyListeners();
  }

  set clear(UserVo? user){
    profile.status = false;
    profile.token = null;
    profile.user = user;
    notifyListeners();
  }
}
