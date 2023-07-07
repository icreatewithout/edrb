import 'package:edrb/common/Api.dart';
import 'package:edrb/common/Global.dart';
import 'package:edrb/controller/ImageHandler.dart';
import 'package:edrb/models/shelf_vo.dart';
import 'package:edrb/widgets/forum/BookListSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

typedef CallBack = void Function();
typedef Cancel = void Function();

class ScanLoginSheet extends StatefulWidget {
  const ScanLoginSheet({
    super.key,
    required this.callBack,
    required this.cancel,
    this.uuid,
  });

  final CallBack callBack;
  final Cancel cancel;
  final String? uuid;

  @override
  State<ScanLoginSheet> createState() => _ScanLoginSheetState();
}

class _ScanLoginSheetState extends State<ScanLoginSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _cancel(BuildContext context) {
    Navigator.of(context).pop();
    widget.cancel();
  }

  void _login(BuildContext context) async {
    EasyLoading.show(status: '登录中');
    int i = await Api(context).scan(widget.uuid!, Global.profile.token!);
    if (i > 0) {
      EasyLoading.dismiss();
      EasyLoading.showToast('登录成功');
      Navigator.of(context).pop();
    } else {
      EasyLoading.dismiss();
      EasyLoading.showToast('登录失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 18,
              right: 18,
              top: kToolbarHeight,
              bottom: kBottomNavigationBarHeight +
                  MediaQuery.of(context).padding.bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.desktop_windows,
                    color: Colors.grey.shade300,
                    size: 120,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    '登录每日阅读',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () => _login(context),
                    child: Container(
                      width: 120,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '确定登录',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () => _cancel(context),
                    child: Container(
                      width: 120,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '取消登录',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
