import 'dart:convert';

import 'package:edrb/pages/circle_page.dart';
import 'package:edrb/pages/mine_page.dart';
import 'package:edrb/pages/read_page.dart';
import 'package:edrb/pages/shelf_page.dart';
import 'package:edrb/widgets/AppBottomBar.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';


class MyHomePage extends StatefulWidget {
  static const String path = "/home";
  final Map? arguments;

  const MyHomePage({super.key, required this.arguments});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ReadPage readPage = const ReadPage();
  final ShelfPage shelfPage = const ShelfPage();
  final CirclePage circlePage = const CirclePage();
  final MinePage minePage = const MinePage();

  final List<Widget> _pages = [];

  @override
  void initState() {
    _pages.add(readPage);
    _pages.add(shelfPage);
    _pages.add(circlePage);
    _pages.add(minePage);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _currentPage = 0;

  void setPage(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Scaffold(
        body: _pages[_currentPage],
        bottomNavigationBar: HomeBottomBar(
          callBack: (index) => setPage(index),
        ),
      ),
    );
  }
}
