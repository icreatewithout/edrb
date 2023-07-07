import 'package:edrb/pages/read_page.dart';
import 'package:edrb/widgets/AppBottomBar.dart';
import 'package:edrb/widgets/ranking/Ranking.dart';
import 'package:edrb/widgets/ranking/RankingBook.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RankingListPage extends StatefulWidget {
  static const String path = "/rang";
  final Map? arguments;

  const RankingListPage({super.key, required this.arguments});

  @override
  State<RankingListPage> createState() => _RankingListState();
}

class _RankingListState extends State<RankingListPage> {
  late String _val = widget.arguments!['val'];
  late Widget _appBar;

  final List<Map<String, String>> _list = [
    {'val': '1001001', 'img': 'assets/sz.png', 'des': '用户热评、强烈推荐的书籍小说'},
    {'val': '2001002', 'img': 'assets/top200.png', 'des': '最受大家喜爱阅读的书籍小说'},
    {'val': '3001003', 'img': 'assets/top50.png', 'des': '近期用户喜欢阅读书籍小说'},
    {'val': '4001004', 'img': 'assets/new50.png', 'des': '用户喜欢的新书'},
  ];

  void _initBar(Map<String, String> map) {
    Widget widget = Container(
      alignment: Alignment.topLeft,
      width: double.maxFinite,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            map['img']!,
            fit: BoxFit.cover,
            height: 30,
            width: 70,
            color: Colors.white,
          ),
          Text(
            map['des']!,
            style: const TextStyle(fontSize: 10),
          )
        ],
      ),
    );
    setState(() {
      _appBar = widget;
    });
  }

  @override
  void initState() {
    super.initState();
    Map<String,String> map = {};
    for (var element in _list) {
      if(_val == element['val']){
        map = element;
      }
    }
    _initBar(map);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setVal(map) {
    setState(() {
      _val = map['val'];
    });
    _initBar(map);
    globalKey.currentState?.changeView(map['val']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
        ),
        title: _appBar,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Ranking(
              current: _val,
              list: _list,
              callBack: (val) => _setVal(val),
            ),
          ),
          Expanded(
            flex: 1,
            child: RankingBook(key: globalKey, val: _val),
          ),
        ],
      ),
    );
  }
}
