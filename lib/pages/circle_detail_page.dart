import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/models/book_forum.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:edrb/util/WidgetUtil.dart';
import 'package:edrb/util/ninepicture/nine_old_widget.dart';
import 'package:edrb/widgets/forum/ForumCommentBottomBar.dart';
import 'package:edrb/widgets/forum/ForumCommentList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CircleDetailPage extends StatefulWidget {
  const CircleDetailPage({super.key, this.arguments});

  static const String path = "/forum/detail";
  final Map? arguments;

  @override
  State<CircleDetailPage> createState() => _CircleDetailPage();
}

class _CircleDetailPage extends State<CircleDetailPage> {
  late BookForum forum = widget.arguments!['forum'];
  int pageNum = 1;
  int pageSize = 10;
  int pageNum1 = 1;
  int pageSize1 = 10;

  bool haveNext = true;
  bool haveNext1 = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _showPicture(BookForum forum) {
    if (forum.pictures == null || forum.pictures!.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.only(bottom: 16),
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
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
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
              height: 76,
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
        ),
        leadingWidth: 0,
        title: Container(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: CommonWidget.gmAvatar(forum.userVo?.avatarUrl,
                        width: 26, height: 26, fit: BoxFit.cover),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        forum.userVo!.nickName!,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '发表于${forum.time}号',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: kBottomNavigationBarHeight +
                      MediaQuery.of(context).padding.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    color: Colors.white,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            forum.des!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        forum.type == '1'
                            ? _showPicture(forum)
                            : _showBook(forum),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ForumCommentList(
                    key: forumCommentListGlobalKey,
                    callBack: (id, name, uid) => forumCommentBottomBarGlobalKey
                        .currentState
                        ?.setId(id, name, uid),
                    id: forum.id!,
                    forum: forum,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ForumCommentBottomBar(
                key: forumCommentBottomBarGlobalKey,
                id: forum.id!,
                forum: forum,
                callBack: (prentId, id) =>
                    forumCommentListGlobalKey.currentState?.update(prentId, id),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
