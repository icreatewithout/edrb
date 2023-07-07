import 'package:edrb/controller/ContentController.dart';
import 'package:flutter/material.dart';

import 'BottomBar.dart';
import 'TopAppBar.dart';

typedef CallBack = void Function(Map<String, String> map);

GlobalKey<_BackColorToolState> backColorToolStateGlobalKey = GlobalKey();

class BackColorTool extends StatefulWidget {
  const BackColorTool({
    super.key,
    required this.bottom,
    required this.height,
    required this.controller,
    required this.color,
  });

  final double bottom;
  final double height;
  final ContentController controller;
  final Color color;

  @override
  State<BackColorTool> createState() => _BackColorToolState();
}

class _BackColorToolState extends State<BackColorTool>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;
  late double bottom = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _animation =
        Tween<double>(begin: 0, end: widget.height).animate(_controller);
  }

  void forward() {
    setState(() {
      bottom = widget.bottom;
    });
    _controller.forward();
  }

  void reset() {
    setState(() {
      bottom = 0;
    });
    _controller.reset();
  }

  void _setColor(Color color, Color? fontColor) {
    widget.controller.setBackgroundColor(color, fontColor);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _list() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 26,
          padding: const EdgeInsets.only(left: 12, right: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade100,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '背景色',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => _setColor(Colors.white, null),
          child: Container(
            height: 30,
            width: 30,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(100)),
            ),
            child: const SizedBox(
              height: 30,
              width: 30,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _setColor(const Color.fromRGBO(199, 237, 204, 1), null),
          child: Container(
            height: 30,
            width: 30,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(199, 237, 204, 1),
              border: Border.all(color: Colors.green, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(100)),
            ),
            child: const SizedBox(
              height: 30,
              width: 30,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _setColor(const Color.fromRGBO(250, 249, 222, 1), null),
          child: Container(
            height: 30,
            width: 30,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(250, 249, 222, 1),
              border: Border.all(color: Colors.brown, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(100)),
            ),
            child: const SizedBox(
              height: 30,
              width: 30,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _setColor(Colors.black, Colors.white),
          child: Container(
            height: 30,
            width: 30,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.black54,
              border: Border.all(color: Colors.blue, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(100)),
            ),
            child: const SizedBox(
              height: 30,
              width: 30,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return SizedBox(
            height: _animation.value,
            child: Container(
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.color,
              ),
              child: _list(),
            ),
          );
        },
      ),
    );
  }
}
