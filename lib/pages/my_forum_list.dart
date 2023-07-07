import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/book_forum.dart';
import 'package:edrb/models/book_rate_vo.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:edrb/pages/circle_detail_page.dart';
import 'package:edrb/util/ninepicture/nine_old_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyForumListPage extends StatefulWidget {
  static const String path = "/my/forum";
  final Map? arguments;

  const MyForumListPage({super.key, required this.arguments});

  @override
  State<MyForumListPage> createState() => _MyForumListPageState();
}

class _MyForumListPageState extends State<MyForumListPage> {
  late final List<BookForum> _forumList = [];

  @override
  void initState() {
    _getRateList();
    super.initState();
  }

  int pageNum = 1;
  int pageSize = 10;
  bool haveNext = true;

  void _getRateList() async {
    Map<String, Object> data = {
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
    List<BookForum> list = await Api().myForumList(data);
    if (list.isNotEmpty && haveNext) {
      setState(() {
        _forumList.addAll(list);
        pageNum++;
        haveNext = true;
      });
    } else {
      setState(() {
        haveNext = false;
      });
    }
  }

  void _del(String id, int index, BuildContext context) async {
    int i = await Api().delForum(id);
    if (i > 0) {
      setState(() {
        _forumList.removeAt(index);
      });
      Navigator.of(context).pop();
    } else {
      EasyLoading.showToast('删除失败');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _forum(BuildContext context, int index) {
    BookForum vo = _forumList[index];
    return GestureDetector(
      onLongPress: () => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            title: const Text(
              "提示",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              "确定删除该帖子吗",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            actions: [
              TextButton(
                child: const Text("取消"),
                onPressed: () {
                  Navigator.of(context).pop(); // 关闭弹框
                },
              ),
              TextButton(
                child:
                    const Text("确定", style: TextStyle(color: Colors.redAccent)),
                onPressed: () => _del(vo.id!, index, context),
              ),
            ],
          );
        },
      ),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          CircleDetailPage.path,
          arguments: {'forum': vo},
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin:
              const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vo.des!),
                  const SizedBox(height: 10),
                  vo.type == '1' ? _showPicture(vo) : _showBook(vo),
                ],
              ),
            ),
            Positioned(
              right: 30,
              top: 15,
              child: Text(
                vo.time!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _showPicture(BookForum forum) {
    if (forum.pictures == null || forum.pictures!.isEmpty) {
      return const SizedBox();
    }
    return Container(
      child: NineOldWidget(
        images: forum.pictures!,
        onLongPressListener: (int position) {},
      ),
    );
  }

  Widget _showBook(BookForum forum) {
    if (forum.books == null || forum.books!.isEmpty) {
      return const SizedBox();
    }

    if (forum.books!.isNotEmpty && forum.books!.length == 1) {
      return _oneBook(forum.books![0]);
    }

    List<String> pictures = [];

    forum.books?.forEach((vo) {
      pictures.add(vo.cover!);
    });

    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: NineOldWidget(
        images: pictures,
        type: '2',
        backgroundColor: Colors.grey.shade300,
        onLongPressListener: (int position) {
          BookVo vo = forum.books![position];
          Navigator.of(context).pushNamed(
            BookDetailPage.path,
            arguments: {'title': '详情', 'name': vo.name, 'id': vo.id},
          );
        },
      ),
    );
  }

  Widget _oneBook(BookVo vo) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          BookDetailPage.path,
          arguments: {'title': '详情', 'name': vo.name, 'id': vo.id},
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              height: 66,
              width: 50,
              imageUrl: vo.cover!,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: Colors.grey),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vo.name!),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    vo.des!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
          '管理我的帖子',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _forumList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index + 1 == _forumList.length && haveNext) {
            _getRateList();
          }
          return _forum(context, index);
        },
      ),
    );
  }
}
