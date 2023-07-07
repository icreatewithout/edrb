import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/book_forum.dart';
import 'package:edrb/models/book_re_view.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/models/user_vo.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:edrb/pages/book_list_detail_page.dart';
import 'package:edrb/pages/circle_detail_page.dart';
import 'package:edrb/util/WidgetUtil.dart';
import 'package:edrb/util/ninepicture/nine_old_widget.dart';
import 'package:edrb/widgets/forum/ForumSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CirclePage extends StatefulWidget {
  const CirclePage({super.key});

  @override
  State<CirclePage> createState() => _CirclePage();
}

class _CirclePage extends State<CirclePage> {
  bool _select = true;
  final Color _selectColor = Colors.blue;
  int pageNum = 1;
  int pageSize = 10;
  int pageNum1 = 1;
  int pageSize1 = 10;
  final List<BookForum> _forumList = [];
  final List<BookReView> _reList = [];
  bool haveNext = true;
  bool haveNext1 = true;

  void _changeSelect() {
    setState(() {
      _select = !_select;
    });
  }

  void _openSheet(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: false,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ForumSheet(
          callBack: (val) => _insertInfo(val),
        );
      },
    );
  }

  void _insertInfo(String id) async {
    BookForum? bf = await Api().bookForum(id);
    if (bf != null) {
      setState(() {
        _forumList.insert(0, bf);
      });
    }
  }

  @override
  void initState() {
    _findList();
    _findReList();
    super.initState();
  }

  void _findList() async {
    Map<String, Object> data = {
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
    List<BookForum> list = await Api().forumList(data);
    if (list.isNotEmpty && mounted) {
      setState(() {
        _forumList.addAll(list);
        pageNum = pageNum + 1;
      });
    } else {
      setState(() {
        haveNext = false;
      });
    }
  }

  void _findReList() async {
    Map<String, Object> data = {
      'pageNum': pageNum1,
      'pageSize': pageSize1,
    };
    List<BookReView> list = await Api().findBookRe(data);
    if (list.isNotEmpty && mounted) {
      setState(() {
        _reList.addAll(list);
        pageNum1 = pageNum1 + 1;
      });
    } else {
      setState(() {
        haveNext1 = false;
      });
    }
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
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
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
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
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
  void dispose() {
    super.dispose();
  }

  Widget _getForumList(BuildContext context, int index) {
    BookForum forum = _forumList[index];
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        CircleDetailPage.path,
        arguments: {'forum': forum},
      ),
      child: Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 18),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _user(forum.userVo!, forum.time!, const SizedBox()),
            _des(forum.des!),
            forum.type == '1' ? _showPicture(forum) : _showBook(forum),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.mode_comment_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        '${forum.comment!}',
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.thumb_up_alt_outlined,
                        color: forum.thumb! ? Colors.redAccent : Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        '${forum.like!}',
                        style: TextStyle(
                            fontSize: 14,
                            color:
                                forum.thumb! ? Colors.redAccent : Colors.grey,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _toDetailPage(BookReView reView, BuildContext context) {
    if (reView.type == '1') {
      Navigator.of(context).pushNamed(BookDetailPage.path, arguments: {
        'title': '详情',
        'name': reView.books![0].name,
        'id': reView.books![0].id
      });
    } else {
      Navigator.of(context).pushNamed(BookListDetailPage.path,
          arguments: {'title': reView.title, 'id': reView.id});
    }
  }

  Widget _getRetList(BuildContext context, int index) {
    BookReView reView = _reList[index];
    return GestureDetector(
      onTap: () => _toDetailPage(reView, context),
      child: Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 8),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _user(reView.user!, reView.time!,
                reView.type == '1' ? _rateBook() : const SizedBox()),
            _des(reView.des!),
            reView.type == '1'
                ? _oneBook(reView.books![0])
                : _books(reView.books!),
          ],
        ),
      ),
    );
  }

  Widget _rateBook() {
    return const Row(
      children: [
        SizedBox(width: 6),
        Icon(
          Icons.sunny,
          size: 14,
          color: Colors.grey,
        ),
        Text(
          '推荐',
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _books(List<BookVo> list) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(14))),
          child: GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, //横轴三个子widget
              childAspectRatio: 1, //宽高比为1时，子widget
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            children: _bookList(list),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "当前书单共${list.length}本书",
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            const Icon(
              Icons.keyboard_arrow_right,
              size: 16,
              color: Colors.grey,
            )
          ],
        )
      ],
    );
  }

  List<Widget> _bookList(List<BookVo> books) {
    List<Widget> list = [];
    int i = 0;
    for (BookVo book in books) {
      if (i > 2) {
        break;
      }
      list.add(
        Container(
          color: Colors.grey.shade200,
          padding:
              const EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 8),
          child: Center(
            child: Image.network(
              book.cover!,
              fit: BoxFit.cover,
              height: 76,
              width: 56,
            ),
          ),
        ),
      );
      i++;
    }
    return list;
  }

  Widget _des(String des) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 16),
      child: Text(
        des,
        style: const TextStyle(fontSize: 16, letterSpacing: 1),
        overflow: TextOverflow.ellipsis,
        maxLines: 5,
      ),
    );
  }

  Widget _user(UserVo user, String time, Widget rate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            user.avatarUrl == null
                ? CommonWidget.gmAvatar(null, width: 26, height: 26)
                : Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: CommonWidget.gmAvatar(user.avatarUrl,
                        width: 26, height: 26, fit: BoxFit.cover),
                  ),
            const SizedBox(
              width: 10,
            ),
            Text(
              user.nickName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            rate,
          ],
        ),
        Text(
          time,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        )
      ],
    );
  }

  Widget _list() {
    int len = 0;
    if (_select) {
      len = _reList.length;
    } else {
      len = _forumList.length;
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: len,
      padding: const EdgeInsets.all(18),
      itemBuilder: (BuildContext context, int index) {
        if (_select) {
          if (index + 1 == _reList.length && haveNext1) {
            _findReList();
          }
          return _getRetList(context, index);
        } else {
          if ((_forumList.isEmpty || index + 1 == _forumList.length) &&
              haveNext) {
            _findList();
          }
          return _getForumList(context, index);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0x00eeeeee),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
        ),
        title: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: kToolbarHeight,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _changeSelect(),
                    child: Text(
                      '推荐',
                      style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: _select == true ? _selectColor : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () => _changeSelect(),
                    child: Text(
                      '书圈儿',
                      style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          color: _select == false ? _selectColor : Colors.grey),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: !_select,
                child: Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _openSheet(context),
                    child: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _list(),
    );
  }
}
