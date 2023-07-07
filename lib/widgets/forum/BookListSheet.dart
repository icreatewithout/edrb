import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/models/shelf_vo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef CallBack = void Function(List<ShelfVo> list);

class BookListSheet extends StatefulWidget {
  const BookListSheet({
    super.key,
    required this.callBack,
    required this.selectList,
    required this.list,
  });

  final CallBack callBack;
  final List<ShelfVo> selectList;
  final List<ShelfVo> list;

  @override
  State<BookListSheet> createState() => _BookListSheetState();
}

class _BookListSheetState extends State<BookListSheet> {
  int _select = 0;

  @override
  void initState() {
    super.initState();
    int i = 0;
    for (ShelfVo shelf in widget.list) {
      for (ShelfVo vo in widget.selectList) {
        if (shelf.id == vo.id) {
          shelf.select = true;
          i = i + 1;
        }
      }
    }
    setState(() {
      _select = i;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _selectDone() {
    List<ShelfVo> list = [];
    for (var vo in widget.list) {
      if (vo.select!) {
        vo.select = false;
        list.add(vo);
      }
    }
    setState(() {
      _select = 0;
    });
    widget.callBack(list);
    Navigator.of(context).pop();
  }

  void changeSelect(String id) {
    if (_select >= 9) {
      EasyLoading.showToast('最多只能选择9本书');
      return;
    }

    for (var vo in widget.list) {
      if (id == vo.id) {
        if (vo.select!) {
          setState(() {
            vo.select = false;
            _select = _select - 1;
          });
        } else {
          setState(() {
            vo.select = true;
            _select = _select + 1;
          });
        }
      }
    }
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
              Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
          ),
          _select == 0 ? const Text('添加书籍') : Text('已选择$_select本'),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  List<Widget> _getChild() {
    List<Widget> list = [];
    for (ShelfVo vo in widget.list) {
      list.add(
        GestureDetector(
          onTap: () => changeSelect(vo.id!),
          child: Container(
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
                        height: 65,
                        width: 50,
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
                            const Icon(Icons.error_outline, color: Colors.grey),
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
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              vo.bookVo!.des!,
                              maxLines: 1,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                vo.select!
                    ? const Icon(
                        Icons.check_circle_outline,
                        color: Colors.blue,
                        size: 16,
                      )
                    : const Icon(
                        Icons.circle_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
              ],
            ),
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          padding: EdgeInsets.only(
              left: 18,
              right: 18,
              top: kToolbarHeight,
              bottom: kBottomNavigationBarHeight +
                  MediaQuery.of(context).padding.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _title(),
              Expanded(
                flex: 1,
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 20),
                  children: _getChild(),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _selectDone(),
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
                      '完成',
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
