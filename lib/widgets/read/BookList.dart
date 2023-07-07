import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:edrb/pages/ranking_list_page.dart';
import 'package:flutter/material.dart';

class BookList extends StatefulWidget {
  const BookList(
      {super.key,
      required this.color,
      required this.title,
      required this.btnName,
      required this.bookList,
      required this.val});

  final String val;
  final String title;
  final String btnName;
  final Color color;
  final List<BookVo> bookList;

  @override
  State<BookList> createState() => _BookList();
}

class _BookList extends State<BookList> {
  @override
  void initState() {
    super.initState();
  }

  final EdgeInsets _margin = const EdgeInsets.only(right: 15);

  final BoxDecoration _boxDecoration =
      const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(2)));

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

  List<Widget> _children() {
    List<Widget> list = [];

    for (var book in widget.bookList) {
      list.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: _margin,
              decoration: _boxDecoration,
              height: 120,
              width: 80,
              child: InkWell(
                child: _getItem(book.cover!),
                onTap: () => Navigator.of(context).pushNamed(
                  BookDetailPage.path,
                  arguments: {'title': '详情', 'name': book.name, 'id': book.id},
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 2),
              width: 80,
              child: Text(
                '${book.name}',
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      );
    }
    return list;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      decoration: BoxDecoration(color: widget.color),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 18, right: 18, bottom: 10),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.only(bottom: 15, left: 18, right: 3),
              child: Row(
                children: _children(),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {
              Navigator.of(context).pushNamed(
                RankingListPage.path,
                arguments: {'val': widget.val},
              )
            },
            child: Container(
              alignment: Alignment.center,
              height: 42,
              margin: const EdgeInsets.only(left: 18, right: 18, top: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300),
              child: Text(
                widget.btnName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey.shade600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
