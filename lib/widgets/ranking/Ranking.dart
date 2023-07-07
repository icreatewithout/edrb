import 'package:flutter/material.dart';

typedef CallBack = void Function(Map<String, String> map);

class Ranking extends StatefulWidget {
  const Ranking(
      {super.key,
      required this.callBack,
      required this.current,
      required this.list});

  final CallBack callBack;
  final String current;
  final List<Map<String, String>> list;

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  late String _current;
  Color unSelectBcColor = Colors.grey.shade100;
  Color selectBcColor = Colors.white;
  Color selectColor = Colors.blue;
  Color unSelectColor = Colors.grey.shade500;

  List<Map<String, String>> _list = [];

  List<Widget> _children() {
    List<Widget> widgets = [];
    for (Map<String, String> map in _list) {
      widgets.add(
        InkWell(
          onTap: () async => _changeSelect(map),
          child: Container(
            color: map['val'] == _current ? selectBcColor : unSelectBcColor,
            alignment: Alignment.center,
            width: 90,
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              map['img']!,
              fit: BoxFit.cover,
              height: 50,
              width: 70,
              color: map['val'] == _current ? selectColor : unSelectColor,
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  @override
  void initState() {
    setState(() {
      _list = widget.list;
      _current = widget.current;
    });
    super.initState();
  }

  void _changeSelect(Map<String, String> map) {
    if (map['val'] != _current) {
      setState(() {
        _current = map['val']!;
      });
      widget.callBack(map);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _children(),
    );
  }
}
