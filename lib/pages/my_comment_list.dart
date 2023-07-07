import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/book_comment_vo.dart';
import 'package:edrb/models/book_forum.dart';
import 'package:edrb/models/book_rate_vo.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:edrb/pages/circle_detail_page.dart';
import 'package:edrb/util/WidgetUtil.dart';
import 'package:edrb/util/ninepicture/nine_old_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyCommentPage extends StatefulWidget {
  static const String path = "/my/comment";
  final Map? arguments;

  const MyCommentPage({super.key, required this.arguments});

  @override
  State<MyCommentPage> createState() => _MyCommentPageState();
}

class _MyCommentPageState extends State<MyCommentPage> {
  late final List<BookCommentVo> _commentList = [];

  @override
  void initState() {
    _getCommentList();
    super.initState();
  }

  int pageNum = 1;
  int pageSize = 10;
  bool haveNext = true;

  void _getCommentList() async {
    Map<String, Object> data = {
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
    List<BookCommentVo> list = await Api().myComment(data);
    if (list.isNotEmpty && haveNext && mounted) {
      setState(() {
        _commentList.addAll(list);
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
        _commentList.removeAt(index);
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

  Widget _comment(BuildContext context, int index) {
    BookCommentVo vo = _commentList[index];
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
              "确定删除该评论吗？",
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
      child: Stack(
        children: [
          Container(
            width: double.infinity,
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
                _showUser(vo),
                Text(
                  vo.des!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
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
    );
  }

  Widget _showUser(BookCommentVo vo) {
    if (vo.replayUser == null) {
      return Container(
        padding: const EdgeInsets.only(bottom: 4),
        child: const Text("我发表的"),
      );
    }
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("我回复 "),
          CommonWidget.gmAvatar(vo.replayUser?.avatarUrl,
              width: 16, height: 16, fit: BoxFit.cover),
          const SizedBox(width: 4),
          Text(vo.replayUser!.nickName ?? ''),
        ],
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
          '管理我的评论',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _commentList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index + 1 == _commentList.length && haveNext) {
            _getCommentList();
          }
          return _comment(context, index);
        },
      ),
    );
  }
}
