import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/book_list_vo.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:edrb/pages/book_list_detail_page.dart';
import 'package:edrb/util/WidgetUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookListPage extends StatefulWidget {
  static const String path = "/bl/page";
  final Map arguments;

  const BookListPage({super.key, required this.arguments});

  @override
  State<BookListPage> createState() => _BookListPage();
}

class _BookListPage extends State<BookListPage> {
  final GlobalKey<_BookListPage> _bookListScaffoldKey =
      GlobalKey<_BookListPage>();

  List<BookListVo> _list = [];

  int _pageNum = 1;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _initBookList();
  }

  void _initBookList() async {
    Map<String, Object> data = {
      'pageNum': _pageNum,
      'pageSize': _pageSize,
    };
    List<BookListVo> list = await Api().blListPage(data);
    if (list.isNotEmpty) {
      if (mounted) {
        setState(() {
          _list = list;
          _pageNum = _pageNum + 1;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _getChild(BuildContext context, int index) {
    BookListVo vo = _list[index];
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vo.title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonWidget.gmAvatar(vo.userVo?.avatarUrl,
                    width: 14, height: 14),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '${vo.userVo?.nickName!}分享的书单',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                )
              ],
            ),
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
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                BookListDetailPage.path,
                arguments: {'title': vo.title, 'id': vo.id}),
            child: Container(
              alignment: Alignment.center,
              height: 40,
              margin: const EdgeInsets.only(left: 18, right: 18, top: 18),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200),
              child: Text(
                '查看书单 ꔷ ${vo.books?.length ?? 0}本书',
                style: TextStyle(
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey.shade600),
              ),
            ),
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _bookListScaffoldKey,
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
        title: Container(
          alignment: Alignment.centerLeft,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '分享书单',
                style: TextStyle(color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _list.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (BuildContext context, int index) {
            if (index + 1 == _list.length) {
              _initBookList();
            }
            return _getChild(context, index);
          },
        ),
      ),
    );
  }
}
