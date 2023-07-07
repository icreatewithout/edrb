import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:flutter/material.dart';

class BookList extends StatefulWidget {
  BookList(this.val) : super(key: ValueKey(val));

  final String val;

  @override
  State<BookList> createState() => _BookList();
}

class _BookList extends State<BookList> {
  late EasyRefreshController _controller;

  int pageNum = 1;
  int pageSize = 10;
  int _count = 0;
  late String _val;
  late List<BookVo> _bookList = [];

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    setState(() {
      _val = widget.val;
      _findList();
    });
  }

  void _onLoad() async {
    setState(() {
      pageNum++;
    });
    _findList();
  }

  void _onRefresh() async {
    setState(() {
      _count = 0;
      _bookList = [];
      pageNum = 1;
    });
    _findList();
    _controller.finishRefresh();
    _controller.resetFooter();
  }

  void _findList() async {
    Map<String, Object> data = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'cVal': _val,
    };
    List<BookVo> list = await Api().findList(data);
    if (list.isNotEmpty) {
      if (!mounted) {
        return;
      }
      setState(() {
        _bookList.addAll(list);
        _count = _bookList.length;
      });
    }
    _controller.finishLoad(IndicatorResult.none);
  }

  Widget _getItem(String imgUrl) {
    return CachedNetworkImage(
      imageUrl: imgUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      errorWidget: (context, url, error) =>
          const Icon(Icons.error, color: Colors.grey),
    );
  }

  Widget _book(BuildContext context, int index) {
    BookVo bookVo = _bookList[index];
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: InkWell(
        onTap: () => {
          Navigator.of(context).pushNamed(
            BookDetailPage.path,
            arguments: {'title': '详情', 'name': bookVo.name, 'id': bookVo.id},
          )
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 110,
              width: 75,
              child: _getItem(bookVo.cover!),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookVo.name!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      bookVo.author!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      bookVo.des!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: _controller,
      header: const ClassicHeader(
          dragText: "下拉刷新",
          readyText: "刷新中...",
          processedText: "刷新完成",
          armedText: "开始刷新",
          showMessage: false),
      footer: const ClassicFooter(
          showMessage: false,
          dragText: '下拉刷新',
          readyText: "加载中...",
          processingText: "加载中...",
          processedText: '加载完成'),
      onRefresh: () async {
        if (!mounted) {
          return;
        }
        _onRefresh();
      },
      onLoad: () async {
        if (!mounted) {
          return;
        }
        _onLoad();
      },
      child: Container(
        color: Colors.white,
        height: double.maxFinite,
        child: ListView.builder(
          itemCount: _count,
          padding: const EdgeInsets.only(left: 10, top: 10),
          itemBuilder: (BuildContext context, int index) {
            return _book(context, index);
          },
        ),
      ),
    );
  }
}
