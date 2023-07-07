import 'package:edrb/pages/circle_page.dart';
import 'package:edrb/pages/mine_page.dart';
import 'package:edrb/pages/read_page.dart';
import 'package:edrb/pages/shelf_page.dart';
import 'package:flutter/material.dart';

typedef CallBack = void Function(int index);

class HomeBottomBar extends StatefulWidget {
  static const String path = "lib/pages/home_page.dart";

  const HomeBottomBar({super.key, required this.callBack});

  final CallBack callBack;

  @override
  State<HomeBottomBar> createState() => _HomeBottomBarState();
}

class _HomeBottomBarState extends State<HomeBottomBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _currentIndex = 0;


  _buildBottomItem(int index, String name, IconData iconData) {
    TextStyle textStyle = const TextStyle(fontSize: 10, color: Colors.grey);
    MaterialColor iconColor = Colors.grey;
    double iconSize = 21;
    if (_currentIndex == index) {
      //选中状态的文字样式
      textStyle = const TextStyle(fontSize: 11, color: Colors.blue);
      //选中状态的按钮样式
      iconColor = Colors.blue;
      iconSize = 22;
    }
    return GestureDetector(
      onTap: () {
        if (index != _currentIndex) {
          setState(() {
            _currentIndex = index;
            widget.callBack(_currentIndex);
          });
        }
      },
      child: SizedBox.fromSize(
        size: const Size(60, 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: iconColor,
              size: iconSize,
            ),
            Text(
              name,
              style: textStyle,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        height: kBottomNavigationBarHeight,
        child: Container(
          height: kBottomNavigationBarHeight,
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomItem(0, '阅读', Icons.chrome_reader_mode_outlined),
              _buildBottomItem(1, '书架', Icons.collections_bookmark_sharp),
              _buildBottomItem(2, '书圈儿', Icons.forum_outlined),
              _buildBottomItem(3, '我', Icons.person),
            ],
          ),
        )
      ),
    );
  }
}
