import 'package:edrb/common/Api.dart';
import 'package:edrb/db/book_data.dart';
import 'package:edrb/pages/about_us.dart';
import 'package:edrb/pages/login_page.dart';
import 'package:edrb/pages/my_comment_list.dart';
import 'package:edrb/pages/my_forum_list.dart';
import 'package:edrb/pages/my_rate_list.dart';
import 'package:edrb/pages/user_info.dart';
import 'package:edrb/states/UserModel.dart';
import 'package:edrb/util/WidgetUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePage();
}

class _MinePage extends State<MinePage> {
  late int readTimeH = 0;
  late int readTimeM = 0;
  late int readTimeS = 0;

  late int readTimeH1 = 0;
  late int readTimeM1 = 0;
  late int readTimeS1 = 0;

  @override
  void initState() {
    _readingTime();
    super.initState();
  }

  void _readingTime() async {
    Map<String, dynamic>? res = await Api().readingTime();
    if (res != null) {
      setState(() {
        readTimeH = res['th']!;
        readTimeM = res['tm']!;
        readTimeS = res['ts']!;
        readTimeH1 = res['h']!;
        readTimeM1 = res['m']!;
        readTimeS1 = res['s']!;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _me(UserModel userModel) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(UserInfoPage.path),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: CommonWidget.gmAvatar(userModel.user?.avatarUrl,
                      width: 56, height: 56, fit: BoxFit.cover),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userModel.user!.nickName!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "编辑个人资料",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Center(
                child: Icon(Icons.keyboard_arrow_right,
                    color: Colors.grey, size: 18),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _noLogin(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(LoginPage.path),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: CommonWidget.gmAvatar(null, width: 56, height: 56),
            ),
            const SizedBox(width: 16),
            const Text(
              '点击登录',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mysub(BuildContext context, UserModel userModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => {
            userModel.isLogin
                ? Navigator.of(context).pushNamed(MyForumListPage.path)
                : Navigator.of(context).pushNamed(LoginPage.path)
          },
          child: Container(
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 0.2, color: Colors.grey))),
            padding: const EdgeInsets.only(bottom: 18),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("我发布的帖子",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Icon(Icons.keyboard_arrow_right, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () => {
            userModel.isLogin
                ? Navigator.of(context).pushNamed(MyRateListPage.path)
                : Navigator.of(context).pushNamed(LoginPage.path)
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 18),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("我发布的点评",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Icon(Icons.keyboard_arrow_right, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _logout(BuildContext context) async {
    await Api(context).logout();
  }

  List<Widget> _format() {
    return [
      Row(
        children: [
          Text(
            '$readTimeH',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black54),
          ),
          const Text('小时', style: TextStyle(fontSize: 12)),
          Text(
            '$readTimeM',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black54),
          ),
          const Text('分钟', style: TextStyle(fontSize: 12)),
        ],
      ),
      const SizedBox(
        height: 4,
      ),
      Row(
        children: [
          Text(
            readTimeH1 > 0 ? '本月$readTimeH1小时' : '本月',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            '$readTimeM1分钟',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      )
    ];
  }

  void _show() {
    showModalBottomSheet(
      useSafeArea: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AnimatedPadding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          duration: Duration.zero,
          child: Container(
            height: 200,
            padding: const EdgeInsets.only(top: 40),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18))),
            alignment: Alignment.center,
            child: const Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('联系我们'),
                  ),
                ),
                Text(
                  'Telegram @xiawuwutongshu',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  'Gmail agdhhjfhtdh585@gmail.com',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  '如有侵权请联系我们删除',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final BookDataProvider bookDataProvider = BookDataProvider();

  void clear() {
    try {
      bookDataProvider.deleteAll();
      EasyLoading.showToast('清除完成');
    } catch (e) {
      EasyLoading.showToast('清除失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0x00eeeeee),
        leadingWidth: 0,
      ),
      body: Consumer<UserModel>(
        builder: (BuildContext context, UserModel userModel, Widget? child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                userModel.isLogin ? _me(userModel) : _noLogin(context),
                Visibility(
                  visible: userModel.isLogin,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.blue),
                            SizedBox(width: 10),
                            Text(
                              '阅读时长',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: _format(),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: _mysub(context, userModel),
                ),
                GestureDetector(
                  onTap: () => {
                    userModel.isLogin
                        ? Navigator.of(context).pushNamed(MyCommentPage.path)
                        : Navigator.of(context).pushNamed(LoginPage.path)
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("我的评论",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        Icon(Icons.keyboard_arrow_right,
                            size: 18, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(AboutUsPage.path),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("关于我们",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        Icon(Icons.keyboard_arrow_right,
                            size: 18, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _show(),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("联系我们",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        Icon(Icons.keyboard_arrow_right,
                            size: 18, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => clear(),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("清除缓存",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        Icon(Icons.keyboard_arrow_right,
                            size: 18, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: userModel.isLogin,
                  child: GestureDetector(
                    onTap: () => _logout(context),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          left: 100, right: 100, top: 50, bottom: 30),
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: const Text("注销登录",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
