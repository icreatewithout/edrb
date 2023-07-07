import 'package:edrb/common/Api.dart';
import 'package:edrb/controller/ImageHandler.dart';
import 'package:edrb/models/shelf_vo.dart';
import 'package:edrb/widgets/forum/BookListSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

typedef CallBack = void Function(String id);

class ForumSheet extends StatefulWidget {
  const ForumSheet({
    super.key,
    required this.callBack,
  });

  final CallBack callBack;

  @override
  State<ForumSheet> createState() => _ForumSheetState();
}

class _ForumSheetState extends State<ForumSheet> {
  late final TextEditingController _controller1 = TextEditingController();
  late final List<XFile> _images = [];
  late ImageHandler _imageHandler;
  bool _showBottomBtn = true;
  late List<ShelfVo> _listShelf = [];
  late List<ShelfVo> _selectList = [];
  late String type = '1'; //1图片2书籍

  @override
  void initState() {
    _imageHandler =
        ImageHandler(del: (i) => _delete(i), select: () => _selectPicture());
    _init();
    super.initState();
  }

  void _init() async {
    List<ShelfVo> list = await Api().shelfList();
    if (list.isNotEmpty) {
      for (ShelfVo vo in list) {
        vo.select = false;
      }
      setState(() {
        _listShelf = list;
      });
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    super.dispose();
  }

  void _setSelect(List<ShelfVo> list) {
    setState(() {
      _selectList = list;
      if (_selectList.isNotEmpty) {
        _showBottomBtn = false;
        type = '2';
      }
    });
  }

  void _delete(int i) {
    setState(() {
      _images.removeAt(i);
      if (_images.isEmpty) {
        _showBottomBtn = true;
      }
    });
  }

  void _selectPicture() async {
    if (_images.length >= 9) {
      return EasyLoading.showToast('最多只能选9张');
    }
    XFile? file = await _imageHandler.selectPicture();
    if (file != null) {
      setState(() {
        _showBottomBtn = false;
        _images.insert(_images.length, file);
        type = '1';
      });
    }
  }

  void _openSheet(BuildContext context) async {
    showModalBottomSheet(
      useSafeArea: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BookListSheet(
          callBack: (list) => _setSelect(list),
          selectList: _selectList,
          list: _listShelf,
        );
      },
    );
  }

  Widget _showBookList(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, //横轴三个子widget
          childAspectRatio: 1, //宽高比为1时，子widget
          crossAxisSpacing: 18.0,
          mainAxisSpacing: 18.0,
        ),
        children: images(context),
      ),
    );
  }

  List<Widget> images(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < _selectList.length; i++) {
      list.add(
        Stack(
          children: [
            Image.network(
              _selectList[i].bookVo!.cover!,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => _del(i),
                child: const Icon(
                  Icons.close,
                  color: Colors.redAccent,
                ),
              ),
            )
          ],
        ),
      );
    }
    if (list.isNotEmpty && list.length < 9) {
      list.add(
        GestureDetector(
          onTap: () => _openSheet(context),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 0.1, color: Colors.grey)),
            child: const Center(
              child: Icon(Icons.add, color: Colors.grey, size: 40),
            ),
          ),
        ),
      );
    }
    return list;
  }

  void _del(int i) {
    setState(() {
      _selectList.removeAt(i);
      if (_selectList.isEmpty) {
        _showBottomBtn = true;
      }
    });
  }

  void _save(BuildContext context) async {
    if (_controller1.text.isEmpty) {
      EasyLoading.showToast('请输入内容');
      return;
    }

    EasyLoading.show(status: '保存中...', maskType: EasyLoadingMaskType.clear);

    Map<String, dynamic> data = {
      'type': type,
      'des': _controller1.text,
    };

    bool next = true;
    if (_images.isNotEmpty) {
      try {
        List<String>? imageId = await Api(context).uploads(_images);
        data['pictures'] = imageId?.join(',');
      } catch (e) {
        next = false;
      }
    }

    if (!next) {
      EasyLoading.showToast('图片上传失败');
      return;
    }

    List<String> bids = [];
    for (ShelfVo sv in _selectList) {
      bids.add(sv.bid!);
      data['bids'] = bids.join(',');
    }

    String? id = await Api(context).saveForum(data);
    if (id != null) {
      widget.callBack(id);
      Navigator.of(context).pop();
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      EasyLoading.showToast('保存失败请重试');
    }
  }

  Widget _getTextFieldDes() {
    return TextField(
      controller: _controller1,
      maxLength: 1000,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        isDense: true,
        hintText: '写下你的想法...',
        counterText: '',
        hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
      ),
      onEditingComplete: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
    );
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _getTextFieldDes(),
                        _imageHandler.showPicture(_images),
                        _showBookList(context),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: _showBottomBtn,
            child: Positioned(
              bottom: kBottomNavigationBarHeight +
                  MediaQuery.of(context).padding.bottom,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          left: 8, right: 12, bottom: 7, top: 7),
                      decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add,
                            color: Colors.blue,
                            size: 16,
                          ),
                          GestureDetector(
                            onTap: () => _selectPicture(),
                            child: const Text(
                              '添加图片',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.blue,
                                  letterSpacing: 1),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _openSheet(context),
                            child: const Text(
                              ' ꔷ 书籍',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.blue,
                                  letterSpacing: 1),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                height: kBottomNavigationBarHeight,
                padding: const EdgeInsets.only(left: 18, right: 18),
                decoration: const BoxDecoration(
                    border: BorderDirectional(
                        top: BorderSide(width: 0.1, color: Colors.grey))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text(
                        '取消',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _save(context),
                      child: const Text(
                        '发表',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
