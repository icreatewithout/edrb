import 'package:edrb/common/Api.dart';
import 'package:edrb/common/Global.dart';
import 'package:edrb/controller/ImageHandler.dart';
import 'package:edrb/models/profile.dart';
import 'package:edrb/models/user_vo.dart';
import 'package:edrb/pages/read_page.dart';
import 'package:edrb/states/ProfileChangeNotifier.dart';
import 'package:edrb/states/UserModel.dart';
import 'package:edrb/util/WidgetUtil.dart';
import 'package:edrb/widgets/AppBottomBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserInfoPage extends StatefulWidget {
  static const String path = "/user/info";
  final Map? arguments;

  const UserInfoPage({super.key, required this.arguments});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late final TextEditingController _controller1 = TextEditingController();
  late final TextEditingController _controller2 = TextEditingController();
  late ImageHandler _imageHandler;
  late String? avatarUrl = '';

  late UserVo? userVo = Global.profile.user;

  @override
  void initState() {
    _imageHandler =
        ImageHandler(del: (i) => {}, select: () => _selectPicture());
    super.initState();
  }

  void _selectPicture() async {
    XFile? file = await _imageHandler.selectPicture();
    if (file != null) {
      String? localPath = await _croppedFile(file);
      if (localPath != null) {
        String? path = await Api().uploadAvatar(localPath, file.name);
        if (path != null) {
          setState(() {
            userVo!.avatarUrl = path;
            avatarUrl = path;
          });
        } else {
          EasyLoading.showToast('上传失败');
        }
      }
    } else {
      EasyLoading.showToast('上传失败');
    }
  }

  Future<String?> _croppedFile(XFile file) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: '头像裁剪',
            statusBarColor: Colors.deepOrange,
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: '头像裁剪',
        ),
        WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 200,
            height: 200,
          ),
          viewPort:
              const CroppieViewPort(width: 200, height: 200, type: 'circle'),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );
    return croppedFile?.path;
  }

  void _updateUser(BuildContext context) async {
    if (avatarUrl!.isEmpty &&
        _controller1.text.isEmpty &&
        _controller2.text.isEmpty) {
      return EasyLoading.showToast('不能更新');
    }
    if (_controller1.text.isNotEmpty) {
      userVo!.nickName = _controller1.text;
    }

    Map<String, Object> data = {
      'path': avatarUrl!,
      'nickName': _controller1.text,
      'passwd': _controller2.text,
    };
    int i = await Api(context).updateUser(data, userVo!);

    if (i < 0) {
      EasyLoading.showToast('更新失败');
    } else {
      EasyLoading.showToast('更新成功');
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text(
          '编辑个人信息',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
        actions: [
          GestureDetector(
            onTap: () => _updateUser(context),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 20),
              padding:
                  const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
              child: const Text(
                '更新',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),
            ),
          )
        ],
      ),
      body: Consumer<UserModel>(
          builder: (BuildContext context, UserModel userModel, Widget? child) {
        return Stack(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _selectPicture(),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 18, right: 18, bottom: 18, top: 20),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 0.1, color: Colors.grey))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('头像',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500)),
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: CommonWidget.gmAvatar(userVo?.avatarUrl,
                                width: 56, height: 56, fit: BoxFit.cover),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 18, right: 18, bottom: 18, top: 20),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(width: 0.1, color: Colors.grey))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('昵称',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500)),
                        Expanded(
                          child: TextField(
                            textAlign: TextAlign.end,
                            controller: _controller1,
                            maxLength: 10,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              isDense: true,
                              hintText: userModel.user?.nickName,
                              counterText: '',
                              hintStyle: const TextStyle(
                                  fontSize: 16, color: Colors.grey),
                            ),
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
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
                  Container(
                    padding: const EdgeInsets.only(
                        left: 18, right: 18, bottom: 18, top: 20),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(width: 0.1, color: Colors.grey))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('密码',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500)),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            autofocus: false,
                            textAlign: TextAlign.end,
                            controller: _controller2,
                            maxLength: 18,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              isDense: true,
                              hintText: '请输入新密码',
                              counterText: '',
                              hintStyle:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
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
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                child: const Column(
                  children: [
                    Text(
                      'Telegram @xiawuwutongshu',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Gmail agdhhjfhtdh585@gmail.com',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '如有侵权请联系我们删除',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
