import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:edrb/widgets/category/BookList.dart';
import 'package:flutter/material.dart';

GlobalKey<_CategoryBook> globalKey = GlobalKey();

class CategoryBook extends StatefulWidget {
  const CategoryBook({super.key, required this.val});

  final String? val;

  @override
  State<CategoryBook> createState() => _CategoryBook();
}

class _CategoryBook extends State<CategoryBook> {

  late String _val;
  late Widget _bookListView = BookList(_val);

  @override
  void initState() {
    super.initState();
    setState(() {
      _val = widget.val!;
    });
  }

  void changeView(String val) {
    setState(() {
      _val = val;
      _bookListView = BookList(val);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _bookListView;
  }
}
