import 'package:edrb/common/Api.dart';
import 'package:edrb/db/book_data.dart';
import 'package:edrb/models/content_vo.dart';
import 'package:edrb/controller/ContentController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

GlobalKey<_BookContentState> bookContentKey = GlobalKey<_BookContentState>();

class BookContent extends StatefulWidget {
  const BookContent({super.key, required this.controller, required this.color});

  final ContentController controller;
  final Color color;

  @override
  State<BookContent> createState() => _BookContentState();
}

class _BookContentState extends State<BookContent> {
  late int _index = 0; //内容分页索引
  late String _currentText = '';
  late List<String> _texts = []; //内容分页
  late ContentVo? _contentVo;

  @override
  void initState() {
    super.initState();
    start();
  }

  void calculate(ContentVo contentVo, BuildContext context) async {
    _texts = await widget.controller.reCalculate(contentVo, context);
    setState(() {
      _currentText = _texts[_index];
    });
  }

  void toCatalog(String cid) async {
    widget.controller.setIsLoading(true);
    widget.controller.setCid(cid);
    ContentVo? contentVo = await widget.controller.getContent('0');
    if (contentVo != null) {
      widget.controller.setIsLoading(false);
      widget.controller.setContent(contentVo);
      _texts = widget.controller.calculate(contentVo);
      setState(() {
        _index = 0;
        _currentText = _texts[0];
      });
    } else {
      widget.controller.setIsLoading(false);
    }
  }

  void start() async {
    ContentVo? contentVo = await widget.controller.getContent('0');
    if (contentVo != null) {
      widget.controller.setContent(contentVo);
      _texts = widget.controller.calculate(contentVo);
      _currentText = _texts[0];
      widget.controller.setIsLoading(false);
    } else {
      widget.controller.setIsLoading(false);
    }
  }

  void next() async {
    ContentVo? contentVo;
    int i = _index + 1;
    if (i >= _texts.length) {
      widget.controller.setIsLoading(true);
      contentVo = await widget.controller.getContent('2');
      if (contentVo == null) {
        widget.controller.setIsLoading(false);
        return EasyLoading.showToast('没有了');
      } else {
        i = 0;
        widget.controller.setContent(contentVo);
        _texts = widget.controller.calculate(contentVo);
        widget.controller.setIsLoading(false);
        setState(() {
          _index = i;
          _currentText = _texts[i];
        });
      }
    } else {
      setState(() {
        _index = i;
        _currentText = _texts[i];
      });
    }
  }

  void prev() async {
    ContentVo? contentVo;
    int i = _index - 1;
    if (i < 0) {
      widget.controller.setIsLoading(true);
      contentVo = await widget.controller.getContent('1');
      if (contentVo == null) {
        widget.controller.setIsLoading(false);
        return EasyLoading.showToast('没有了');
      } else {
        widget.controller.setContent(contentVo);
        _texts = widget.controller.calculate(contentVo);
        widget.controller.setIsLoading(false);
        i = _texts.length - 1;
        setState(() {
          _index = i;
          _currentText = _texts[i];
        });
      }
    } else {
      setState(() {
        _index = i;
        _currentText = _texts[i];
      });
    }
  }

  @override
  void dispose() {
    _index = 0;
    _currentText = '';
    _texts = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: widget.color,
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.only(
              left: widget.controller.getSae, right: widget.controller.getSae),
          child: SingleChildScrollView(
            child: Center(
              child: Text(
                _currentText,
                style: TextStyle(
                    color: widget.controller.getFontColor,
                    fontSize: widget.controller.getSize,
                    height: widget.controller.getHeight),
              ),
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: Visibility(
            visible: _texts.isNotEmpty,
            child: Text(
              '${_index + 1} / ${_texts.length}',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Visibility(
          visible: widget.controller.isLoading,
          child: Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 30.0,
                  height: 30.0,
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
