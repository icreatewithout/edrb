import 'dart:ffi';

import 'package:edrb/common/Global.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/models/category.dart';
import 'package:edrb/pages/login_page.dart';
import 'package:edrb/pages/scanner_page.dart';
import 'package:edrb/pages/search_page.dart';
import 'package:edrb/widgets/read/BookList.dart';
import 'package:edrb/widgets/read/ReadCategory.dart';
import 'package:edrb/widgets/read/ReadRecord.dart';
import 'package:edrb/widgets/read/Recommend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common/Api.dart';
import '../widgets/Search.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({super.key});

  @override
  State<ReadPage> createState() => _ReadPage();
}

class _ReadPage extends State<ReadPage> {
  @override
  void initState() {
    _init();
    _getCategory();
    super.initState();
  }

  late List<Category> categories = [];

  void _getCategory() async {
    List<Category> list = await Api().category();
    if (mounted) {
      setState(() {
        categories = list;
      });
    }
  }

  late List<BookVo> greatList = [];
  late List<BookVo> top200 = [];
  late List<BookVo> top50 = [];

  void _init() async {
    Map<String, Object> data = {'pageNum': 1, 'pageSize': 8};
    List<BookVo> list = await Api().homeGreat(data);
    if (mounted) {
      setState(() {
        greatList = list;
      });
    }
    list = await Api().top200(data);
    if (mounted) {
      setState(() {
        top200 = list;
      });
    }

    list = await Api().top50(data);
    if (mounted) {
      setState(() {
        top50 = list;
      });
    }
  }

  to(val) async {}

  @override
  void dispose() {
    super.dispose();
  }

  void _toScan(BuildContext context) {
    if (!Global.profile.status) {
      Navigator.of(context).pushNamed(LoginPage.path);
    } else {
      Navigator.of(context).pushNamed(ScannerPage.path);
    }
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
        title: Search(
          width: 30,
          height: 40,
          hintText: '搜索关键字',
          onSearch: (val) => Navigator.of(context)
              .pushNamed(SearchPage.path, arguments: {'val': val}),
          onClear: () => {},
          suffix: const Icon(Icons.qr_code, color: Colors.grey),
          onRightTap: () => _toScan(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ReadCategory(
                categories: categories,
              ),
            ),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ReadRecord(),
            ),
            const Recommend(),
            BookList(
              color: const Color(0x00eeeeee),
              title: '总榜单',
              btnName: '查看总榜',
              bookList: top200,
              val: "2001002",
            ),
            BookList(
              color: Colors.white,
              title: '热门榜单',
              btnName: '查看热门榜',
              bookList: top50,
              val: "3001003",
            ),
            BookList(
              color: const Color(0x00eeeeee),
              title: '神作榜单',
              btnName: '查看神作榜',
              bookList: greatList,
              val: "1001001",
            ),
            const BookList(
              color: Colors.white,
              title: '新书榜单',
              btnName: '查看新书榜',
              bookList: [],
              val: "4001004",
            ),
          ],
        ),
      ),
    );
  }
}
