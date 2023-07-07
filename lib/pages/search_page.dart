import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/author.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/pages/author_book_page.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/Search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.arguments});

  static const String path = "/search";
  final Map? arguments;

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  late String? _val = widget.arguments?['val'];

  int _pageNum = 1;
  final int _pageSize = 5;

  List<BookVo> _books = [];

  List<Author> _authors = [];

  @override
  void initState() {
    print('$_val');
    super.initState();
    Map<String, Object> data = {
      'searchVal': _val!,
      'pageNum': _pageNum,
      'pageSize': _pageSize
    };
    _findAuthor(data);
    _findBook(data);
  }

  void _setVal(String val) {
    setState(() {
      _books = [];
      _authors = [];
      _pageNum = 1;
      _val = val;
      _current = 0;
      _loadMore();
      _loadAuthor();
    });
  }

  void _loadMore() {
    Map<String, Object> data = {
      'searchVal': _val!,
      'pageNum': _pageNum,
      'pageSize': _pageSize
    };
    _findBook(data);
  }

  void _loadAuthor() {
    Map<String, Object> data = {
      'searchVal': _val!,
    };
    _findAuthor(data);
  }

  void _findAuthor(Map<String, Object> data) async {
    List<Author> list = await Api().searchAuthor(data);
    if (list.isNotEmpty) {
      setState(() {
        _authors = list;
      });
    }
  }

  void _findBook(Map<String, Object> data) async {
    List<BookVo> list = await Api().searchBook(data);
    if (list.isNotEmpty) {
      setState(() {
        _books.addAll(list);
        _pageNum = _pageNum + 1;
      });
    }
  }

  Widget _getAuthors() {
    List<Widget> list = [];
    for (Author author in _authors) {
      Color color = Colors.grey;
      if (_authors.last == author) {
        color = Colors.transparent;
      }
      list.add(GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          AuthorBookPage.path,
          arguments: {'name': author.author},
        ),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 14, bottom: 14),
          decoration: BoxDecoration(
              border: BorderDirectional(
                  bottom: BorderSide(width: 0.1, color: color))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/avatar1.png', width: 40, height: 40),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(author.author!),
                  Text(
                    '该作者共有${author.count!}本书',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
    }
    return Column(
      children: list,
    );
  }

  Widget _getBookList(BuildContext context, int index) {
    BookVo book = _books[index];
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        BookDetailPage.path,
        arguments: {'title': book.name, 'name': book.name, 'id': book.id},
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 110,
              width: 75,
              child: CachedNetworkImage(
                imageUrl: book.cover!,
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
                      book.name!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      book.author!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      book.des!,
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

  final TextStyle _select =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  final TextStyle _unSelect = const TextStyle();
  int _current = 0;

  void _changeCurrent() {
    if (_current == 0) {
      setState(() {
        _current = 1;
      });
    } else {
      setState(() {
        _current = 0;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x00eeeeeee),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0x00eeeeee),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
        ),
        leadingWidth: 0,
        title: Search(
          width: 30,
          height: 40,
          hintText: '搜索作者、书籍',
          onSearch: (val) => _setVal(val),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.only(
                left: 2,
                top: 10,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _changeCurrent(),
                    child:
                        Text('作者', style: _current == 0 ? _select : _unSelect),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  GestureDetector(
                    onTap: () => _changeCurrent(),
                    child:
                        Text('书籍', style: _current == 1 ? _select : _unSelect),
                  ),
                ],
              ),
            ),
            _current == 0
                ? Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Container(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: _getAuthors(),
                    ),
                  )
                : Expanded(
                    flex: 1,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _books.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index + 1 == _books.length) {
                          _loadMore();
                        }
                        return _getBookList(context, index);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
