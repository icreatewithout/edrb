import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/book_forum.dart';
import 'package:edrb/models/book_forum_comment_vo.dart';
import 'package:edrb/models/book_list_comment_vo.dart';
import 'package:edrb/models/book_list_count.dart';
import 'package:edrb/models/user_vo.dart';
import 'package:edrb/util/WidgetUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef CallBack = void Function(String id, String name, String uid);

GlobalKey<_ForumCommentListState> forumCommentListGlobalKey = GlobalKey();

class ForumCommentList extends StatefulWidget {
  const ForumCommentList({
    super.key,
    required this.callBack,
    required this.id,
    required this.forum,
  });

  final CallBack callBack;
  final String id;
  final BookForum forum;

  @override
  State<ForumCommentList> createState() => _ForumCommentListState();
}

class _ForumCommentListState extends State<ForumCommentList> {
  int pageNum = 1;
  int pageSize = 10;
  int pageNum1 = 1;
  int pageSize1 = 10;
  int pageNum2 = 1;
  int pageSize2 = 10;
  late final List<BookForumCommentVo> _commentList = [];
  late final List<UserVo> _likeList = [];

  @override
  void initState() {
    super.initState();
    _findList();
    _findLikeList();
  }

  bool haveNext1 = true;

  void _findLikeList() async {
    Map<String, Object> data = {
      'pageNum': pageNum1,
      'pageSize': pageSize1,
      'bfId': widget.id,
    };
    List<UserVo> list = await Api().bfLikeList(data);
    if (list.isNotEmpty && mounted) {
      setState(() {
        _likeList.addAll(list);
        pageNum1 = pageNum1 + 1;
      });
    } else {
      setState(() {
        haveNext1 = false;
      });
    }
  }

  bool haveNext = true;

  void _findList() async {
    Map<String, Object> data = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'bfId': widget.id,
    };
    List<BookForumCommentVo> list = await Api().bfCommentList(data);
    if (list.isNotEmpty && mounted) {
      setState(() {
        _commentList.addAll(list);
        pageNum = pageNum + 1;
      });
    } else {
      setState(() {
        haveNext = false;
      });
    }
  }

  late String id = '';

  void _findChildren(String prentId, String bfId, int index) async {
    if (id != prentId) {
      setState(() {
        id = prentId;
        pageNum2 = 1;
      });
    }
    Map<String, Object> data = {
      'pageNum': pageNum2,
      'pageSize': pageSize2,
      'bfId': widget.id,
      'prentId': prentId,
    };
    List<BookForumCommentVo> list = await Api().bfCommentList(data);
    if (list.isNotEmpty && mounted) {
      BookForumCommentVo vo = _commentList[index];
      vo.children ??= [];
      setState(() {
        vo.children?.addAll(list);
        pageNum2 = pageNum2 + 1;
      });
    }
  }

  void update(String? prentId, String id) async {
    BookForumCommentVo? detail = await Api().bookForumCommentDetail(id);
    if (detail != null) {
      if (detail.prentId == '0') {
        setState(() {
          _commentList.insert(0, detail);
        });
      } else {
        for (BookForumCommentVo vo in _commentList) {
          if (vo.id == detail.prentId) {
            vo.children ??= [];
            setState(() {
              vo.child = vo.child! + 1;
              vo.children?.insert(0, detail);
            });
            break;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _select = 0;
  final Color _unSelectColor = Colors.grey;

  Widget _tab() {
    return Container(
      decoration: const BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(width: 0.2, color: Colors.grey),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 2),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => setState(() {
              _select = 0;
            }),
            child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(
                        width: 1,
                        color: _select == 0 ? Colors.blue : Colors.transparent),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '评论',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _select == 0 ? Colors.blue : _unSelectColor,
                          fontSize: 16),
                    ),
                  ],
                )),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () => setState(() {
              _select = 1;
            }),
            child: Container(
              padding: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(
                      width: 1,
                      color: _select == 1 ? Colors.blue : Colors.transparent),
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '赞',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _select == 1 ? Colors.blue : _unSelectColor,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getLikeList(BuildContext context, int index) {
    UserVo vo = _likeList[index];
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: CommonWidget.gmAvatar(vo.avatarUrl,
                width: 26, height: 26, fit: BoxFit.cover),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: Text(
              vo.nickName!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _list() {
    int len = 0;
    if (_select == 0) {
      len = _commentList.length;
    } else {
      len = _likeList.length;
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: len,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      itemBuilder: (BuildContext context, int index) {
        if (_select == 0) {
          if (index + 1 == _commentList.length && haveNext) {
            _findList();
          }
          return _getCommentList(context, index);
        } else {
          if (index + 1 == _likeList.length && haveNext1) {
            _findLikeList();
          }
          return _getLikeList(context, index);
        }
      },
    );
  }

  List<Widget> _getChildren(List<BookForumCommentVo> list) {
    List<Widget> widgets = [];
    for (var vo in list) {
      widgets.add(
        Container(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: CommonWidget.gmAvatar(vo.user?.avatarUrl,
                    width: 26, height: 26, fit: BoxFit.cover),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: _commentWidget(vo),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _getCommentList(BuildContext context, int index) {
    BookForumCommentVo vo = _commentList[index];
    return GestureDetector(
      onTap: () => widget.callBack(vo.id!, vo.user!.nickName!, vo.user!.id!),
      child: Container(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: CommonWidget.gmAvatar(vo.user?.avatarUrl,
                  width: 26, height: 26, fit: BoxFit.cover),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _commentWidget(vo),
                  Column(
                    children: _getChildren(vo.children ?? []),
                  ),
                  _moreWidget(vo, index),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _commentWidget(BookForumCommentVo vo) {
    return GestureDetector(
      onTap: () => widget.callBack(vo.prentId == '0' ? vo.id! : vo.prentId!,
          vo.user!.nickName!, vo.user!.id!),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _replyWidget(vo),
          const SizedBox(height: 2),
          Text(
            vo.des!,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            vo.time!,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _replyWidget(BookForumCommentVo vo) {
    if (vo.replayUser?.nickName == null || vo.replayUser?.id == vo.user?.id) {
      return Text(
        vo.user!.nickName!,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
      );
    }
    return Row(
      children: [
        Text(
          vo.user!.nickName!,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(
          child: Icon(
            Icons.play_arrow_rounded,
            color: Colors.grey,
            size: 16,
          ),
        ),
        Text(
          '${vo.replayUser?.nickName}',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _moreWidget(BookForumCommentVo vo, int index) {
    String txt = '展开更多回复';
    if (vo.children == null || vo.children!.isEmpty) {
      txt = '展开${vo.child}条回复';
    }
    if (vo.child == 0 || vo.children?.length == vo.child) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () => _findChildren(vo.id!, vo.bfId!, index),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: 0.5, width: 16, color: Colors.grey),
          const SizedBox(width: 10),
          Text(
            txt,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tab(),
          _list(),
        ],
      ),
    );
  }
}
