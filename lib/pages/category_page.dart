import 'package:edrb/common/Api.dart';
import 'package:edrb/models/category.dart';
import 'package:edrb/widgets/Search.dart';
import 'package:edrb/widgets/category/CategoryBook.dart';
import 'package:edrb/widgets/category/CategoryList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CategoryPage extends StatefulWidget {
  static const String path = "/category";
  final Map arguments;

  const CategoryPage({super.key, required this.arguments});

  @override
  State<CategoryPage> createState() => _CategoryPage();
}

class _CategoryPage extends State<CategoryPage> {
  late List<Category>? _categories;
  late String? _currentIndex;
  late String? _val;
  late String? _name = '';

  @override
  void initState() {
    setState(() {
      _categories = widget.arguments['list'];
      _currentIndex = _categories![0].id;
      _val = _categories![0].val;
      _name = _categories![0].name;
    });
    super.initState();
  }

  void _setVal(String id) {
    _categories?.forEach((element) {
      if (id == element.id) {
        setState(() {
          _val = element.val;
          _name = element.name;
          globalKey.currentState?.changeView(element.val);
        });
      }
    });
  }

  ValueChanged<String>? _onSearch(String? val) {
    globalKey.currentState?.changeView(_val!);
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.1,
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
          title: Text(
            _name!,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        body: Visibility(
          visible: _categories != null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: CategoryList(
                  categories: _categories!,
                  current: _currentIndex!,
                  callBack: (val) => _setVal(val),
                ),
              ),
              Expanded(
                flex: 1,
                child: CategoryBook(key: globalKey, val: _val),
              ),
            ],
          ),
        ));
  }
}
