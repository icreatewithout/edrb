import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';

class Recommend extends StatefulWidget {
  const Recommend({super.key});

  @override
  State<Recommend> createState() => _Recommend();
}

class _Recommend extends State<Recommend> {
  @override
  void initState() {
    _getData();
    super.initState();
  }

  final EdgeInsets _margin = const EdgeInsets.all(0);
  final BoxDecoration _boxDecoration =
      const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(2)));

  Widget _getItem(String imgUrl) {
    return Center(
      child: CachedNetworkImage(
        imageUrl: imgUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        errorWidget: (context, url, error) =>
            const Icon(Icons.error, color: Colors.grey),
      ),
    );
  }

  late List<BookVo> bookList = [];

  List<Widget> _children() {
    List<Widget> list = [];
    for (var book in bookList) {
      list.add(
        Container(
          margin: _margin,
          decoration: _boxDecoration,
          child: InkWell(
              child: _getItem(book.cover!),
              onTap: () => {
                    Navigator.of(context).pushNamed(
                      BookDetailPage.path,
                      arguments: {
                        'title': '详情',
                        'name': book.name,
                        'id': book.id
                      },
                    )
                  }),
        ),
      );
    }
    return list;
  }

  void _getData() async {
    List<BookVo> list = await Api().homeRand({'size': 6});
    if (mounted) {
      setState(() {
        bookList = list;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.only(top: 20, left: 18, right: 18, bottom: 20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "为你推荐",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              letterSpacing: 1,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 15),
            child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, //横轴三个子widget
                childAspectRatio: 0.75, //宽高比为1时，子widget
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 18.0,
              ),
              children: _children(),
            ),
          ),
          GestureDetector(
            onTap: () => {_getData()},
            child: Container(
              alignment: Alignment.center,
              height: 42,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300),
              child: Text(
                "换一批",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey.shade600),
              ),
            ),
          )
        ],
      ),
    );
  }
}
