import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/category.dart';
import 'package:flutter/material.dart';

typedef CallBack = void Function(String id);

class CategoryList extends StatefulWidget {
  CategoryList({
    super.key,
    required this.categories,
    required this.current,
    required this.callBack,
  });

  final List<Category> categories;
  final String current;
  final CallBack callBack;

  @override
  State<CategoryList> createState() => _CategoryList();
}

class _CategoryList extends State<CategoryList> {
  @override
  void initState() {
    setState(() {
      _categories = widget.categories;
      _current = widget.current;
    });
    super.initState();
  }

  late List<Category> _categories;
  late String _current;

  void _changeSelect(String id) {
    if (id != _current) {
      setState(() {
        _current = id;
      });
      widget.callBack(id);
    }
  }

  Color unSelectTextColor = Colors.grey.shade700;
  Color selectTextColor = Colors.blue;
  Color selectColor = Colors.white;
  Color unSelectColor = const Color(0x00eeeeee);

  List<Widget> _children() {
    List<Widget> widgets = [];
    for (Category category in _categories) {
      widgets.add(
        InkWell(
          onTap: () => {_changeSelect(category.id)},
          child: Container(
            width: 90,
            color: category.id == _current ? selectColor : unSelectColor,
            padding:
                const EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 20),
            child: Text(
              category.name,
              style: TextStyle(
                  color: category.id == _current
                      ? selectTextColor
                      : unSelectTextColor,
                  fontSize: 13),
            ),
          ),
        ),
      );
    }
    return widgets;
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
