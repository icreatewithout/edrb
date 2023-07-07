import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/shelf_vo.dart';
import 'package:edrb/widgets/shelf/SelectSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef CallBack = void Function(String id);

class CreateSheet extends StatefulWidget {
  const CreateSheet({
    super.key,
    required this.callBack,
    required this.list,
  });

  final CallBack callBack;
  final List<ShelfVo> list;

  @override
  State<CreateSheet> createState() => _CreateSheetState();
}

class _CreateSheetState extends State<CreateSheet> {
  late final TextEditingController _controller1 = TextEditingController();
  late final TextEditingController _controller2 = TextEditingController();
  List<ShelfVo> _selectList = [];

  String _status = '0';

  @override
  void initState() {
    super.initState();
  }

  void _setStatus() {
    if (_status == '0') {
      setState(() {
        _status = '1';
      });
    } else {
      setState(() {
        _status = '0';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }

  void _sub(BuildContext context) async {
    if (_controller1.text.isEmpty) {
      return EasyLoading.showToast('请输入标题');
    }
    if (_controller2.text.isEmpty) {
      return EasyLoading.showToast('请输入描述内容');
    }
    if (_selectList.isEmpty) {
      return EasyLoading.showToast('还没有选择书籍');
    }

    List<String> ids = [];
    for (ShelfVo vo in _selectList) {
      ids.add(vo.bookVo!.id);
    }
    Map<String, Object> data = {
      'title': _controller1.text,
      'des': _controller2.text,
      'bids': ids.join(','),
      'status': _status,
    };

    int i = await Api(context).subBookList(data);

    if (i == 0) {
      Navigator.of(context).pop();
    } else {
      EasyLoading.showToast('提交失败');
    }
  }

  void _setSelect(List<ShelfVo> list) {
    setState(() {
      _selectList = list;
    });
  }

  List<Widget> _getChild() {
    List<Widget> list = [];
    for (ShelfVo vo in _selectList) {
      list.add(
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    CachedNetworkImage(
                      height: 85,
                      width: 60,
                      imageUrl: vo.bookVo!.cover!,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(2)),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vo.bookVo!.name!,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            vo.bookVo!.des!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _delSelect(vo.id!),
                child: const Icon(
                  Icons.close,
                  color: Colors.redAccent,
                  size: 18,
                ),
              )
            ],
          ),
        ),
      );
    }
    return list;
  }

  void _delSelect(String id) {
    List<ShelfVo> list = [];
    for (var vo in _selectList) {
      if (vo.id != id) {
        list.add(vo);
      }
    }
    setState(() {
      _selectList = list;
    });
  }

  Widget _selectListWidget() {
    return Column(
      children: _getChild(),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      useSafeArea: false,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AnimatedPadding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          duration: Duration.zero,
          child: SelectSheet(
            key: selectSheetGlobalKey,
            callBack: (val) => _setSelect(val),
            selectList: _selectList,
            list: widget.list,
          ),
        );
      },
    );
  }

  Widget _title() {
    return Container(
      color: const Color(0x00eeeeee),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.close,
              color: Colors.grey,
            ),
          ),
          const Text('新建书单'),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _getTextFieldTitle() {
    return TextField(
      controller: _controller1,
      maxLength: 50,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          isDense: true,
          hintText: '点击输入标题',
          counterText: '',
          hintStyle: TextStyle(fontSize: 18, color: Colors.grey)),
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      onEditingComplete: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
    );
  }

  Widget _getTextFieldDes() {
    return TextField(
      controller: _controller2,
      maxLength: 255,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        isDense: true,
        hintText: '点击输入描述',
        counterText: '',
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      style: const TextStyle(color: Colors.grey, fontSize: 14),
      onEditingComplete: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
    );
  }

  Widget _addGestureDetector() {
    return GestureDetector(
      onTap: () => _showBottomSheet(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 110,
            width: 75,
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            decoration: BoxDecoration(
                border: Border.all(width: 0.2, color: Colors.grey)),
            child: const Center(
              child: Icon(Icons.add, color: Colors.grey, size: 40),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          const Text(
            '添加书籍',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          padding: EdgeInsets.only(
              left: 18,
              right: 18,
              top: kToolbarHeight,
              bottom: kBottomNavigationBarHeight +
                  MediaQuery.of(context).padding.bottom),
          child: Column(
            children: [
              _title(),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        decoration: const BoxDecoration(
                            border: BorderDirectional(
                                bottom: BorderSide(
                                    width: 0.2, color: Colors.grey))),
                        child: Column(
                          children: [
                            _getTextFieldTitle(),
                            _getTextFieldDes(),
                          ],
                        ),
                      ),
                      _addGestureDetector(),
                      _selectListWidget(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 56,
            margin:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            padding: const EdgeInsets.only(
              left: 18,
              right: 18,
            ),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: BorderDirectional(
                    top: BorderSide(width: 0.1, color: Colors.grey))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _setStatus(),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _status == '0'
                            ? const Icon(
                                Icons.circle_outlined,
                                size: 16,
                                color: Colors.blue,
                              )
                            : const Icon(
                                Icons.check_circle_outlined,
                                size: 16,
                                color: Colors.blue,
                              ),
                        const Text('同步到圈子',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _sub(context),
                  child: Container(
                    height: 36,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade300,
                    ),
                    child: const Text(
                      '发布',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
