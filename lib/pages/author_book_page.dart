import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/author_book.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthorBookPage extends StatefulWidget {
  const AuthorBookPage({super.key, this.arguments});

  static const String path = "/author/book";
  final Map? arguments;

  @override
  State<AuthorBookPage> createState() => _AuthorBookPage();
}

class _AuthorBookPage extends State<AuthorBookPage> {
  late AuthorBook? _authorBook = AuthorBook();

  @override
  void initState() {
    super.initState();
    _searchBook();
  }

  void _searchBook() async {
    Map<String, Object> data = {'name': widget.arguments?['name']};
    AuthorBook? authorBook = await Api().searchAuthorBook(data);
    if (authorBook != null) {
      setState(() {
        _authorBook = authorBook;
      });
    }
  }

  Widget _getBookList(BuildContext context, int index) {
    BookVo book = _authorBook!.list![index];
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        BookDetailPage.path,
        arguments: {'title': book.name, 'name': book.name, 'id': book.id},
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
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

  @override
  void dispose() {
    super.dispose();
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
        title: const Text(
          "作者作品",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '作者 ${widget.arguments!['name']}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '当前作者共有 ${_authorBook!.count ?? 0}本书',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    _authorBook!.list == null ? 0 : _authorBook!.list!.length,
                itemBuilder: (BuildContext context, int index) {
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
