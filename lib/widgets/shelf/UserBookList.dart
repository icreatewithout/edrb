import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/book_list_vo.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/models/shelf_vo.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:edrb/pages/book_list_detail_page.dart';
import 'package:edrb/pages/content_page.dart';
import 'package:edrb/widgets/shelf/CreateSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef CallBack = void Function(int len, int i);

GlobalKey<_UserBookList> userBookListGlobalKey = GlobalKey();

class UserBookList extends StatefulWidget {
  const UserBookList({
    super.key,
    required this.callBack,
    required this.list,
  });

  final CallBack callBack;
  final List<ShelfVo> list;

  @override
  State<UserBookList> createState() => _UserBookList();
}

class _UserBookList extends State<UserBookList> {
  List<BookListVo> _list = [];
  int _pageNum = 1;
  final int _pageSize = 10;
  bool haveNext = true;

  @override
  void initState() {
    _initBookList(context);
    super.initState();
  }

  void _refresh(BuildContext context) {
    setState(() {
      _list = [];
      _pageNum = 1;
      _initBookList(context);
    });
  }

  void _initBookList(BuildContext context) async {
    Map<String, Object> data = {
      'pageNum': _pageNum,
      'pageSize': _pageSize,
    };
    List<BookListVo> list = await Api(context).blList(data);
    if (list.isNotEmpty) {
      if (mounted) {
        setState(() {
          _list = list;
          _pageNum = _pageNum + 1;
        });
      }
    } else {
      setState(() {
        haveNext = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _getChild(BuildContext context, int index) {
    BookListVo vo = _list[index];
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(BookListDetailPage.path,
          arguments: {
            'title': vo.title,
            'id': vo.id
          }).then((value) => _refresh(context)),
      child: Container(
        padding:
            const EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  vo.title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${vo.books?.length}本',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: Colors.grey,
                    )
                  ],
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 12),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, //横轴三个子widget
                  childAspectRatio: 0.75, //宽高比为1时，子widget
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 18.0,
                ),
                children: _children(vo.books!),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _children(List<BookVo> voList) {
    List<Widget> list = [];
    for (int i = 0; voList.length > 4 ? i < 4 : i < voList.length; i++) {
      BookVo vo = voList[i];
      list.add(GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          BookDetailPage.path,
          arguments: {'title': '详情', 'name': vo.name, 'id': vo.id},
        ),
        child: CachedNetworkImage(
          height: 96,
          width: 70,
          imageUrl: vo.cover!,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          errorWidget: (context, url, error) =>
              const Icon(Icons.error, color: Colors.grey),
        ),
      ));
    }

    return list;
  }

  void showBottomSheet() {
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
          child: CreateSheet(
            callBack: (val) => {},
            list: widget.list,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _list.length,
      itemBuilder: (BuildContext context, int index) {
        if (index + 1 == _list.length && haveNext) {
          _initBookList(context);
        }
        return _getChild(context, index);
      },
    );
  }
}
