import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/book_list_count.dart';
import 'package:edrb/models/book_list_vo.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/models/user_vo.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:edrb/states/UserModel.dart';
import 'package:edrb/widgets/booklist/CommentBottomBar.dart';
import 'package:edrb/widgets/booklist/CommentList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BookListDetailPage extends StatefulWidget {
  const BookListDetailPage({super.key, this.arguments});

  static const String path = "/booklist/detail";
  final Map? arguments;

  @override
  State<BookListDetailPage> createState() => _BookListDetailPage();
}

class _BookListDetailPage extends State<BookListDetailPage> {
  late BookListVo _bookListVo = BookListVo();
  late List<BookVo> _bookVos = [];
  late UserVo _userVo = UserVo();
  late BookListCount _count = BookListCount();
  late String _status = '0';
  late final String _id = widget.arguments!['id'];

  @override
  void initState() {
    super.initState();
    _init();
    _countBookList(widget.arguments!['id']);
  }

  void _init() async {
    BookListVo? bookListVo = await Api().blDetail(widget.arguments!['id']);
    if (bookListVo != null) {
      setState(() {
        _bookListVo = bookListVo;
        _status = bookListVo.status!;
        _bookVos = bookListVo.books!;
        _userVo = bookListVo.userVo!;
      });
    }
  }

  void _countBookList(id) async {
    BookListCount? res = await Api().countBookList(id);
    if (res != null) {
      setState(() {
        _count = res;
      });
    }
  }

  void _del(BuildContext context) async {
    Navigator.of(context).pop();
    int i = await Api(context).delBookList(_bookListVo.id!);
    if (i == 0) {
      EasyLoading.showToast('已删除');
      Navigator.of(context).pop();
    } else {
      EasyLoading.showToast('删除失败');
    }
  }

  void _sync(BuildContext context) async {
    Navigator.of(context).pop();
    int i = await Api(context).syncBookList(_bookListVo.id!);
    if (i == 0) {
      EasyLoading.showToast('同步成功');
      setState(() {
        _status = '1';
      });
    } else {
      EasyLoading.showToast('同步失败');
    }
  }

  Widget _getAvatar(String? url) {
    if (null == url) {
      return Image.asset(
        'assets/avatar1.png',
        height: 20,
        width: 20,
      );
    }
    return CachedNetworkImage(
      height: 20,
      width: 20,
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      errorWidget: (context, url, error) =>
          const Icon(Icons.error, color: Colors.grey),
    );
  }

  Widget _infoWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 18, right: 18, top: 20, bottom: 20),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: BorderDirectional(
              bottom: BorderSide(width: 0.1, color: Colors.grey))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_bookListVo.title ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 10),
          Text(
            _bookListVo.des ?? '',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getAvatar(_userVo.avatarUrl),
              const SizedBox(width: 10),
              Text(
                '${_userVo.nickName ?? ''}的书单',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              )
            ],
          )
        ],
      ),
    );
  }

  List<Widget> _getChild() {
    List<Widget> list = [];
    for (BookVo vo in _bookVos) {
      list.add(
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            BookDetailPage.path,
            arguments: {'title': '详情', 'name': vo.name, 'id': vo.id},
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  height: 85,
                  width: 60,
                  imageUrl: vo.cover!,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(2)),
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
                        vo.name!,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        vo.des!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return list;
  }

  Widget _syncWidget(UserModel userModel) {
    if (_status == '0') {
      return IconButton(
        tooltip: '同步到书圈儿',
        onPressed: () => Alert(
          context: context,
          title: "提示",
          desc: "确定同步到书圈儿吗",
          buttons: [
            DialogButton(
              onPressed: () => Navigator.pop(context),
              color: Colors.grey,
              child: const Text(
                "取消",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            DialogButton(
              onPressed: () => _sync(context),
              color: Colors.blue,
              child: const Text(
                "确定",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ).show(),
        icon: const Icon(
          Icons.sync,
          color: Colors.blue,
        ),
      );
    }

    return IconButton(
      tooltip: '已同步',
      onPressed: () => EasyLoading.showToast('已同步'),
      icon: const Icon(
        Icons.sync,
        color: Colors.grey,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget? child) {
        return Scaffold(
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
            title: Text(
              '书单${widget.arguments?['title']}',
              style: const TextStyle(color: Colors.black),
            ),
            actions: [
              Visibility(
                  visible:
                      userModel.isLogin && userModel.user?.id == _userVo.id,
                  child: _syncWidget(userModel)),
              Visibility(
                visible: userModel.isLogin && userModel.user?.id == _userVo.id,
                child: IconButton(
                  onPressed: () => Alert(
                    context: context,
                    title: "提示",
                    desc: "确定删除吗",
                    buttons: [
                      DialogButton(
                        onPressed: () => Navigator.pop(context),
                        color: Colors.grey,
                        child: const Text(
                          "取消",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      DialogButton(
                        onPressed: () => _del(context),
                        color: Colors.redAccent,
                        child: const Text(
                          "删除",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    ],
                  ).show(),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                ),
              )
            ],
          ),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      bottom: kBottomNavigationBarHeight +
                          MediaQuery.of(context).padding.bottom),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoWidget(),
                        Container(
                          padding:
                          const EdgeInsets.only(top: 10, left: 18, right: 18),
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _getChild(),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.only(
                              left: 18, right: 18, top: 10, bottom: 10),
                          child: Text(
                            '共${_bookVos.length}本书  ꔷ  创建于${_bookListVo.time ?? ''}',
                            style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        CommentList(
                          key: commentListGlobalKey,
                          callBack: (id, name, uid) => commentBottomBarGlobalKey
                              .currentState
                              ?.setId(id, name, uid),
                          id: _id,
                          count: _count,
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CommentBottomBar(
                    key: commentBottomBarGlobalKey,
                    id: _id,
                    count: _count,
                    callBack: (prentId, id) =>
                        commentListGlobalKey.currentState?.update(prentId, id),
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
  }
}
