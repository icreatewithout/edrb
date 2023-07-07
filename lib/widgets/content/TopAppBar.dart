import 'package:edrb/controller/ContentController.dart';
import 'package:flutter/material.dart';

typedef CallBack = void Function(Map<String, String> map);

GlobalKey<_TopAppBarState> topAppBarGlobalKey = GlobalKey();

class TopAppBar extends StatefulWidget {
  const TopAppBar({
    super.key,
    required this.top,
    required this.height,
    required this.controller,
    required this.color,
    required this.name,
  });

  final double top;
  final double height;
  final ContentController controller;
  final Color color;
  final String name;

  @override
  State<TopAppBar> createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween<double>(begin: 0, end: widget.height + widget.top)
        .animate(_controller);
  }

  void forward() {
    _controller.forward();
  }

  void reset() {
    _controller.reset();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: kToolbarHeight,
      backgroundColor: widget.color,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 18,
          color: widget.controller.getFontColor,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.name ?? '',
          style: TextStyle(color: widget.controller.getFontColor, fontSize: 18),
        ),
      ),
      // actions: [
      //   Container(
      //     alignment: Alignment.center,
      //     child: Container(
      //       decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(3), color: Colors.grey),
      //       padding:
      //           const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
      //       child: widget.controller.getContentVo!.shelf
      //           ? const Text(
      //               "已加书架",
      //               style: TextStyle(color: Colors.white, fontSize: 10),
      //             )
      //           : const Text(
      //               "加入书架",
      //               style: TextStyle(color: Colors.white, fontSize: 10),
      //             ),
      //     ),
      //   ),
      //   IconButton(
      //     onPressed: () => {},
      //     color: Colors.black,
      //     splashRadius: 2,
      //     padding: const EdgeInsets.all(5),
      //     icon: const Icon(Icons.share_outlined),
      //   )
      // ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return SizedBox(
            height: _animation.value,
            child: _appBar(),
          );
        },
      ),
    );
  }
}
