
import 'package:edrb/widgets/ranking/RBookList.dart';
import 'package:flutter/material.dart';

GlobalKey<_RankingBookState> globalKey = GlobalKey();

class RankingBook extends StatefulWidget {
  const RankingBook({super.key, required this.val});

  final String? val;

  @override
  State<RankingBook> createState() => _RankingBookState();
}

class _RankingBookState extends State<RankingBook> {

  late String _val;
  late Widget _bookListView = RBookList(_val);

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
      _bookListView = RBookList(val);
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
