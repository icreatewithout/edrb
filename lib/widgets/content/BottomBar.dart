import 'package:edrb/common/Api.dart';
import 'package:edrb/controller/ContentController.dart';
import 'package:edrb/models/content_vo.dart';
import 'package:edrb/widgets/detail/CatalogSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

typedef CallBack = void Function(String id);
typedef Calculate = void Function(ContentVo vo);
typedef ShowColorTool = void Function();

GlobalKey<_BottomBarState> bottomAppBarGlobalKey = GlobalKey();

class BottomBar extends StatefulWidget {
  const BottomBar({
    super.key,
    required this.height,
    required this.bottom,
    required this.controller,
    required this.callBack,
    required this.calculate,
    required this.color,
    required this.showColorTool,
  });

  final double bottom;
  final double height;
  final ContentController controller;
  final CallBack callBack;
  final Calculate calculate;
  final ShowColorTool showColorTool;
  final Color color;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;
  bool isCache = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween<double>(begin: 0, end: widget.height + widget.bottom)
        .animate(_controller);
  }

  void forward() {
    _controller.forward();
  }

  void reset() {
    _controller.reset();
  }

  void _openSheet(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CatalogSheet(
          callBack: (cid) => {widget.callBack(cid), Navigator.pop(context)},
          id: widget.controller.getBid,
          backColor: widget.controller.getColor,
          fontColor: widget.controller.getFontColor,
        );
      },
    );
  }

  Future<void> _changeFont(int i) async {
    double? size = widget.controller.getSize;
    size = size! + i;

    if (size > 26 || size < 12) {
      return EasyLoading.showToast('达到最大值');
    }

    widget.controller.changSize(size);
    ContentVo? contentVo = widget.controller.getContentVo;
    if (contentVo != null) {
      widget.calculate(contentVo);
    }
  }

  void _cacheBook(BuildContext context) async {
    if (isCache) {
      return EasyLoading.showToast('正在缓存');
    }
    setState(() {
      EasyLoading.showToast('开始缓存');
      widget.controller.cacheContent(context);
      isCache = true;
    });
  }

  void _showColorTool() {
    widget.showColorTool();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _bottomBar() {
    return Consumer(
      builder:
          (BuildContext context, ContentController controller, Widget? child) {
        return Container(
          height: _animation.value,
          padding: EdgeInsets.only(left: 18, right: 18, bottom: widget.bottom),
          decoration: BoxDecoration(
            color: widget.color,
            border: BorderDirectional(
              top: BorderSide(width: 0.1, color: Colors.grey.shade400),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _openSheet(context),
                child: const Icon(
                  Icons.chrome_reader_mode_outlined,
                  size: 26,
                  color: Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () => _showColorTool(),
                child: SizedBox.fromSize(
                  size: Size(45, widget.height),
                  child: const Icon(
                    Ionicons.sunny_outline,
                    size: 26,
                    color: Colors.grey,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _changeFont(2),
                child: Container(
                  alignment: Alignment.center,
                  height: 45,
                  child: const Row(
                    children: [
                      Icon(
                        Ionicons.text_outline,
                        size: 26,
                        color: Colors.grey,
                      ),
                      Text(
                        '+',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _changeFont(-2),
                child: Container(
                  alignment: Alignment.center,
                  height: 45,
                  child: const Row(
                    children: [
                      Icon(
                        Ionicons.text_outline,
                        size: 26,
                        color: Colors.grey,
                      ),
                      Text(
                        '-',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _cacheBook(context),
                child: SizedBox.fromSize(
                  size: Size(45, widget.height),
                  child: const Icon(
                    Ionicons.download_outline,
                    size: 26,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return SizedBox(
            height: _animation.value,
            child: _bottomBar(),
          );
        },
      ),
    );
  }
}
