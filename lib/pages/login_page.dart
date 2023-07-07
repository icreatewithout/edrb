import 'package:edrb/common/Api.dart';
import 'package:edrb/pages/read_page.dart';
import 'package:edrb/widgets/AppBottomBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';

class LoginPage extends StatefulWidget {
  static const String path = "/login";
  final Map? arguments;

  const LoginPage({super.key, required this.arguments});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  Future<void> _login(BuildContext context) async {
    if (_controller1.text.isEmpty) {
      return EasyLoading.showToast(
        '请输入账号',
        toastPosition: EasyLoadingToastPosition.top,
      );
    }
    if (_controller1.text.length < 3 || _controller1.text.length > 9) {
      return EasyLoading.showToast(
        '用户名长度4-10个字符',
        toastPosition: EasyLoadingToastPosition.top,
      );
    }
    if (_controller2.text.isEmpty) {
      return EasyLoading.showToast(
        '请输入密码',
        toastPosition: EasyLoadingToastPosition.top,
      );
    }
    if (_controller2.text.length < 5 || _controller2.text.length > 17) {
      return EasyLoading.showToast(
        '密码长度6-18个字符',
        toastPosition: EasyLoadingToastPosition.top,
      );
    }

    Map<String, Object> map = {
      'username': _controller1.text,
      'password': _controller2.text
    };

    await Api(context).login(map);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }

  late Widget _currentPage = const ReadPage();

  void setPage(Widget page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.only(
          left: 18,
          right: 18,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(9)),
              child: Image.asset(
                'assets/logo.png',
                height: 64,
                width: 64,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 20, bottom: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                children: [
                  const Text(
                    '登录每日阅读',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 2, bottom: 5),
                    child: const Text('账号'),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.maxFinite,
                    height: 48,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 30,
                          height: 48,
                          child: Center(
                            child: Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            autofocus: false,
                            focusNode: _focusNode1,
                            controller: _controller1,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '请输入用户名',
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              hintStyle:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            style: const TextStyle(fontSize: 16),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            onTap: () {},
                            // 输入框内容改变回调
                            onChanged: (val) {},
                            onSubmitted: (val) {},
                            onEditingComplete: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              /// 键盘是否是弹起状态,弹出且输入完成时收起键盘
                              if (!currentFocus.hasPrimaryFocus &&
                                  currentFocus.focusedChild != null) {
                                FocusManager.instance.primaryFocus!.unfocus();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 2, bottom: 5),
                    child: const Text('密码'),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.maxFinite,
                    height: 48,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 30,
                          height: 48,
                          child: Center(
                            child: Icon(
                              Icons.password,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            autofocus: false,
                            focusNode: _focusNode2,
                            controller: _controller2,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '请输入密码',
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              hintStyle:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            obscureText: true,
                            style: const TextStyle(fontSize: 16),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            onTap: () {},
                            // 输入框内容改变回调
                            onChanged: (val) {},
                            onSubmitted: (val) {},
                            onEditingComplete: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              /// 键盘是否是弹起状态,弹出且输入完成时收起键盘
                              if (!currentFocus.hasPrimaryFocus &&
                                  currentFocus.focusedChild != null) {
                                FocusManager.instance.primaryFocus!.unfocus();
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: GFButton(
                color: Colors.blue,
                onPressed: () => _login(context),
                text: "登录",
                size: GFSize.LARGE,
                fullWidthButton: true,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                '提示：首次登录会自动创建账号，注意保存密码，账号不记名，丢失无法找回！',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}
