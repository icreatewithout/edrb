import 'package:edrb/common/Api.dart';
import 'package:edrb/models/shelf_vo.dart';
import 'package:edrb/pages/login_page.dart';
import 'package:edrb/states/UserModel.dart';
import 'package:edrb/widgets/shelf/ShelfList.dart';
import 'package:edrb/widgets/shelf/UserBookList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class ShelfPage extends StatefulWidget {
  const ShelfPage({super.key});

  @override
  State<ShelfPage> createState() => _ShelfPage();
}

class _ShelfPage extends State<ShelfPage> with SingleTickerProviderStateMixin {
  final TextStyle _select = const TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue);
  final TextStyle _unSelect = const TextStyle();

  late List<ShelfVo> _list = [];
  int _current = 0;
  bool _isCk = false;
  int _len = 0;
  int _selectNum = 0;

  void _setSelect(len, i) {
    setState(() {
      _len = len;
      _selectNum = i;
    });
  }

  void _changeCurrent() {
    if (_current == 0) {
      setState(() {
        _current = 1;
      });
    } else {
      setState(() {
        _current = 0;
      });
    }
  }

  Widget _selectWidget(UserModel userModel, bool ck) {
    return GestureDetector(
      onTap: () {
        if (!userModel.isLogin) {
          EasyLoading.showToast('请先登录');
        } else {
          setState(() {
            _isCk = !_isCk;
          });
          shelfGlobalKey.currentState?.setCk();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _isCk ? const Text('取消') : const Text('选择'),
        ],
      ),
    );
  }

  Widget _addWidget(UserModel userModel) {
    return GestureDetector(
      onTap: () {
        if (!userModel.isLogin) {
          EasyLoading.showToast('请先登录');
        } else {
          userBookListGlobalKey.currentState?.showBottomSheet();
        }
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.add,
            size: 16,
          ),
          Text('新建书单')
        ],
      ),
    );
  }

  Widget _selectText(bool ck) {
    if (ck) {
      return Container(
        alignment: Alignment.center,
        child: _selectNum < 1
            ? const Text(
                '选择书籍',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              )
            : Text(
                '已选择 $_selectNum 本书籍',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
              ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _leftTab(bool ck) {
    if (ck) {
      return GestureDetector(
        onTap: () => shelfGlobalKey.currentState?.selectAll(),
        child: _selectNum == _len && _selectNum != 0
            ? const Text('取消全选')
            : const Text('全选'),
      );
    } else {
      return Row(
        children: [
          GestureDetector(
            onTap: () => _changeCurrent(),
            child: Text('书架', style: _current == 0 ? _select : _unSelect),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () => _changeCurrent(),
            child: Text('书单', style: _current == 1 ? _select : _unSelect),
          ),
        ],
      );
    }
  }

  @override
  void initState() {
    _init(context);
    super.initState();
  }

  _refresh(BuildContext context) {
    _init(context);
  }

  void _init(BuildContext context) async {
    List<ShelfVo> list = await Api(context).shelfList();
    if (list.isNotEmpty) {
      for (ShelfVo vo in list) {
        vo.select = false;
      }
      setState(() {
        _list = list;
        shelfGlobalKey.currentState?.setList(list);
      });
    }
  }

  void _delete() async {
    shelfGlobalKey.currentState?.delete();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0x00eeeeee),
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.white,
            ),
            leadingWidth: 0,
            title: const Text(
              '我的书架',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            actions: [
              _isCk
                  ? IconButton(
                      onPressed: () => _delete(),
                      icon: const Icon(
                        Icons.delete_sweep,
                        color: Colors.redAccent,
                        semanticLabel: '移除书籍',
                      ),
                    )
                  : const SizedBox()
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 55,
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      decoration: const BoxDecoration(
                        border: BorderDirectional(
                          bottom: BorderSide(color: Colors.grey, width: 0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: _leftTab(_isCk),
                          ),
                          Expanded(
                            flex: 1,
                            child: _selectText(_isCk),
                          ),
                          Expanded(
                            flex: 1,
                            child: _current == 0
                                ? _selectWidget(userModel, _isCk)
                                : _addWidget(userModel),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: userModel.isLogin,
                      child: Expanded(
                        flex: 1,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 20),
                            child: _current == 0
                                ? ShelfList(
                                    key: shelfGlobalKey,
                                    callBack: (len, i) => _setSelect(len, i),
                                    list: _list,
                                  )
                                : UserBookList(
                                    list: _list,
                                    key: userBookListGlobalKey,
                                    callBack: (len, i) => {},
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: !userModel.isLogin,
                  child: Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('还未登录，请先登录'),
                          Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.only(
                                left: 50, right: 50, top: 10),
                            child: GFButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(LoginPage.path)
                                  .then((value) => _refresh(context)),
                              text: "登录",
                              size: GFSize.LARGE,
                              fullWidthButton: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
