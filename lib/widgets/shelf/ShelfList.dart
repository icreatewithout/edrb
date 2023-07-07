import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/shelf_vo.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:edrb/pages/content_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef CallBack = void Function(int len, int i);

GlobalKey<_ShelfList> shelfGlobalKey = GlobalKey();

class ShelfList extends StatefulWidget {
  const ShelfList({
    super.key,
    required this.callBack,
    required this.list,
  });

  final CallBack callBack;
  final List<ShelfVo> list;

  @override
  State<ShelfList> createState() => _ShelfList();
}

class _ShelfList extends State<ShelfList> {
  final BoxDecoration _boxDecoration =
      const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(2)));

  late List<ShelfVo> _list = [];
  bool _isCk = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _list = widget.list;
    });
  }

  void setList(List<ShelfVo> list) {
    setState(() {
      _list = list;
    });
  }

  void delete() async {
    List<ShelfVo> list = [];
    List<String> select = [];
    _list.forEach((vo) {
      if (vo.select == true) {
        select.add(vo.id!);
      } else {
        list.add(vo);
      }
    });

    if (select.isEmpty) {
      return EasyLoading.showToast('请选择书籍');
    }

    int i = await Api().delShelf(select.join(','));
    if (i == 0) {
      EasyLoading.showToast('移除成功');
      setState(() {
        _list = list;
      });
    } else {
      EasyLoading.showToast('移除失败请重试');
    }
  }

  void setCk() {
    setState(() {
      _isCk = !_isCk;
      if (!_isCk) {
        for (ShelfVo vo in _list) {
          vo.select = false;
        }
        widget.callBack(_list.length, _getI());
      }
    });
  }

  void showBottomBar() {}

  void selectAll() {
    int i = _getI();
    bool select = true;
    if (i == _list.length) {
      select = false;
    }
    setState(() {
      for (ShelfVo vo in _list) {
        vo.select = select;
      }
    });
    widget.callBack(_list.length, _getI());
  }

  void _ck(BuildContext context, ShelfVo shelf) {
    if (_isCk) {
      setState(() {
        shelf.select = !shelf.select!;
        widget.callBack(_list.length, _getI());
      });
    } else {
      if (shelf.cid == null) {
        Navigator.of(context).pushNamed(
          BookDetailPage.path,
          arguments: {
            'title': '详情',
            'name': shelf.bookVo!.name,
            'id': shelf.bid
          },
        );
      } else {
        Navigator.of(context).pushNamed(ContentPage.path, arguments: {
          'bid': shelf.bid,
          'cid': shelf.cid,
          'name': shelf.bookVo!.name,
        });
      }
    }
  }

  int _getI() {
    int i = 0;
    _list.forEach((element) {
      if (element.select!) {
        i++;
      }
    });
    return i;
  }

  List<Widget> _children() {
    List<Widget> list = [];
    for (var shelf in _list) {
      list.add(
        Stack(
          children: [
            Container(
              decoration: _boxDecoration,
              child: InkWell(
                child: _getItem(shelf.bookVo!.cover!, shelf.bookVo!.name!),
                onTap: () => _ck(context, shelf),
              ),
            ),
            Visibility(
              visible: _isCk,
              child: Positioned(
                right: 3,
                top: 3,
                child: Icon(
                  Icons.check_circle_outlined,
                  color: shelf.select ?? false ? Colors.blue : Colors.white,
                ),
              ),
            )
          ],
        ),
      );
    }
    return list;
  }

  Widget _getItem(String imgUrl, String name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: CachedNetworkImage(
            imageUrl: imgUrl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: Colors.grey),
          ),
        ),
        Text(name, maxLines: 1, overflow: TextOverflow.ellipsis)
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, //横轴三个子widget
        childAspectRatio: 0.65, //宽高比为1时，子widget
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 18.0,
      ),
      children: _children(),
    );
  }
}
