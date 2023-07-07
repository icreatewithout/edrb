import 'package:edrb/models/category.dart';
import 'package:edrb/pages/book_list_page.dart';
import 'package:edrb/pages/category_page.dart';
import 'package:edrb/pages/ranking_list_page.dart';
import 'package:flutter/material.dart';

class ReadCategory extends StatefulWidget {
  const ReadCategory({super.key, required this.categories});

  final List<Category> categories;

  @override
  State<ReadCategory> createState() => _ReadCategory();
}

class _ReadCategory extends State<ReadCategory> {
  @override
  void initState() {
    super.initState();
  }

  final EdgeInsets _margin = const EdgeInsets.only(right: 10);
  final EdgeInsets _edgeInsets =
      const EdgeInsets.only(left: 13, right: 13, top: 5, bottom: 5);

  final BoxDecoration _boxDecoration = BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: const BorderRadius.all(Radius.circular(20)));

  Widget _getItem(String name, IconData id) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(name, style: const TextStyle(fontSize: 12)),
        Icon(id, size: 10)
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 18, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: _margin,
            padding: _edgeInsets,
            decoration: _boxDecoration,
            child: InkWell(
                child: _getItem('分类', Icons.arrow_forward_ios_rounded),
                onTap: () => {
                      if (widget.categories.isNotEmpty &&
                          widget.categories != [])
                        {
                          Navigator.of(context).pushNamed(
                            CategoryPage.path,
                            arguments: {
                              'title': '分类',
                              'list': widget.categories
                            },
                          )
                        }
                    }),
          ),
          Container(
            margin: _margin,
            padding: _edgeInsets,
            decoration: _boxDecoration,
            child: InkWell(
                child: _getItem('书单', Icons.arrow_forward_ios_rounded),
                onTap: () => Navigator.of(context).pushNamed(
                  BookListPage.path,
                  arguments: {},
                )),
          ),
          Container(
            margin: _margin,
            padding: _edgeInsets,
            decoration: _boxDecoration,
            child: InkWell(
                child: _getItem('榜单', Icons.arrow_forward_ios_rounded),
                onTap: () => Navigator.of(context).pushNamed(
                      RankingListPage.path,
                      arguments: {'val': '1001001'},
                    )),
          ),
        ],
      ),
    );
  }
}
