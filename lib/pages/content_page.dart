import 'package:edrb/common/Api.dart';
import 'package:edrb/db/book_data.dart';
import 'package:edrb/models/content_vo.dart';
import 'package:edrb/widgets/content/BackColorTool.dart';
import 'package:edrb/widgets/content/BookContent.dart';
import 'package:edrb/widgets/content/BottomBar.dart';
import 'package:edrb/controller/ContentController.dart';
import 'package:edrb/widgets/content/TopAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ContentPage extends StatefulWidget {
  static const String path = "/content";
  final Map? arguments;

  const ContentPage({super.key, required this.arguments});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  late final String _bid = widget.arguments!['bid'];
  late final String _cid = widget.arguments!['cid'];
  late final String name = widget.arguments!['name'];
  late ContentController _controller;

  bool _showBar = false;

  double _centerWidthLeft = 0.0; //左宽边界
  double _centerWidthRight = 0.0; //右宽边界
  double _centerHeightTop = 0.0; //上边界
  double _centerHeightBottom = 0.0; //下边界

  late Color _backgroundColor;

  @override
  void initState() {
    super.initState();
  }

  void _init(BuildContext context, ContentController controller) {
    _controller = controller;
    controller.init(context, _bid, _cid, true);
    //获取屏幕宽高
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    double w = width / 3;
    double h = height / 4;
    _centerWidthLeft = w;
    _centerWidthRight = w * 2;
    _centerHeightTop = h;
    _centerHeightBottom = h * 3;

    _backgroundColor = controller.getColor;
  }

  void _getPosition(BuildContext context, TapDownDetails info) async {
    if (_controller.isLoading) {
      return;
    }

    final tapPosition = info.globalPosition;
    final x = tapPosition.dx;
    final y = tapPosition.dy;

    bool w = x > _centerWidthLeft && x < _centerWidthRight;
    if (w) {
      setState(() {
        _showBar = !_showBar;
      });
      if (_showBar) {
        topAppBarGlobalKey.currentState?.forward();
        bottomAppBarGlobalKey.currentState?.forward();
      } else {
        topAppBarGlobalKey.currentState?.reset();
        bottomAppBarGlobalKey.currentState?.reset();
        backColorToolStateGlobalKey.currentState?.reset();
      }
    }

    bool tapRight = y > _centerHeightTop &&
        y < _centerHeightBottom &&
        x > _centerWidthRight;
    if (tapRight && !_showBar) {
      bookContentKey.currentState?.next();
    }

    bool tapLeft =
        y > _centerHeightTop && y < _centerHeightBottom && x < _centerWidthLeft;
    if (tapLeft && !_showBar) {
      bookContentKey.currentState?.prev();
    }

    await Api().saveReadTime(_bid);
  }

  void _toCatalog(String cid) {
    setState(() {
      _showBar = !_showBar;
    });
    topAppBarGlobalKey.currentState?.reset();
    bottomAppBarGlobalKey.currentState?.reset();
    bookContentKey.currentState?.toCatalog(cid);
  }

  void _calculate(ContentVo vo, BuildContext context) {
    bookContentKey.currentState?.calculate(vo, context);
  }

  void _showColorTool() {
    backColorToolStateGlobalKey.currentState?.forward();
  }

  @override
  void dispose() {
    _controller.stopCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContentController>(
      builder:
          (BuildContext context, ContentController controller, Widget? child) {
        _init(context, controller);
        return Stack(
          children: [
            Scaffold(
              backgroundColor: controller.getColor,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: controller.getColor,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: controller.getColor,
                  systemNavigationBarColor: controller.getColor,
                ),
                leadingWidth: 0,
                leading: const SizedBox(),
                title: Text(
                  controller.getContentVo?.catalog ?? '',
                  style:
                      TextStyle(color: controller.getFontColor, fontSize: 14),
                ),
              ),
              body: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: GestureDetector(
                  onTapDown: (info) => _getPosition(context, info),
                  child: BookContent(
                    key: bookContentKey,
                    controller: controller,
                    color: controller.getColor,
                  ),
                ),
              ),
            ),
            TopAppBar(
              key: topAppBarGlobalKey,
              height: kToolbarHeight,
              top: MediaQuery.of(context).padding.top,
              controller: controller,
              color: controller.getColor,
              name: name,
            ),
            BottomBar(
              key: bottomAppBarGlobalKey,
              height: kBottomNavigationBarHeight,
              bottom: MediaQuery.of(context).padding.bottom,
              controller: controller,
              callBack: (cid) => _toCatalog(cid),
              calculate: (vo) => _calculate(vo, context),
              showColorTool: () => _showColorTool(),
              color: controller.getColor,
            ),
            BackColorTool(
              key: backColorToolStateGlobalKey,
              bottom: kBottomNavigationBarHeight +
                  MediaQuery.of(context).padding.bottom,
              height: 70,
              controller: controller,
              color: controller.getColor,
            )
          ],
        );
      },
    );
  }
}
