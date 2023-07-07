import 'dart:ffi';
import 'dart:ui';

import 'package:edrb/common/Api.dart';
import 'package:edrb/common/Global.dart';
import 'package:edrb/db/book_data.dart';
import 'package:edrb/models/content_vo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final BookDataProvider _bookDataProvider = BookDataProvider();

class ContentController extends ChangeNotifier {
  static const String _val = '汉';

  BuildContext? _buildContext;
  bool _isLoading = true;
  late String _bid;
  late String _cid;

  late double? _size = Global.profile.fontSize ?? 18; //默认字体大小
  late double? _height = 1.4; //行间距
  late double _sae = 20; //start and end 页面padding

  late EdgeInsetsGeometry padding;
  late TextPainter textPainter;

  late Color _backgroundColor = Global.profile.backgroundColor == null
      ? Colors.white
      : Color(Global.profile.backgroundColor!);
  late Color _fontColor = Global.profile.fontColor == null
      ? Colors.black
      : Color(Global.profile.fontColor!);

  Color get getColor => _backgroundColor;

  Color get getFontColor => _fontColor;

  double? _pageWidth = 0; //页面内容宽度
  double? _pageHeight = 0; //页面内容高度
  int? _textWidth = 0; //每行字数
  int? _textHeight = 0; //行高

  late ContentVo? _contentVo = null;

  String get getBid => _bid;

  double? get getSize => _size;

  double? get getHeight => _height;

  int? get getTextHeight => _textHeight;

  EdgeInsetsGeometry get getPadding => padding;

  double get getSae => _sae;

  ContentVo? get getContentVo => _contentVo;

  bool get isLoading => _isLoading;

  void init(
      BuildContext buildContext, String bid, String cid, bool loading) async {
    _bid = bid;
    _cid = cid;
    _buildContext = buildContext;
    await _initPadding(buildContext);
    await _getWH(buildContext);
    await _initTextPainter();
  }

  void setCid(String cid) {
    _cid = cid;
  }

  void setIsLoading(bool b) async {
    _isLoading = b;
    notifyListeners();
  }

  void close() {
    _bookDataProvider.close();
  }

  void setBackgroundColor(Color color, Color? fontColor) async {
    _backgroundColor = color;
    if (fontColor != null) {
      _fontColor = fontColor;
      Global.profile.fontColor = fontColor.value;
    } else {
      _fontColor = Colors.black;
      Global.profile.fontColor = 0xFF000000;
    }
    Global.profile.backgroundColor = color.value;
    Global.saveProfile();
    notifyListeners();
  }

  void setContent(ContentVo? contentVo) {
    _contentVo = contentVo;
    notifyListeners();
  }

  bool _isStop = false;

  void stopCache() {
    _isStop = true;
  }

  Future<void> cacheContent(BuildContext context) async {
    String cid = '0';
    BookData? book = await _bookDataProvider.getByBid(_bid);
    if (book != null) {
      cid = book.cid!;
    }
    try {
      List<ContentVo> list = await Api(context).cache(_bid, cid);
      if (list.isNotEmpty) {
        for (ContentVo vo in list) {
          BookData bd = BookData.fromMap(vo.toJson());
          await _bookDataProvider.insert(bd);
        }
        if (!_isStop) {
          await cacheContent(context);
        }
      } else {
        EasyLoading.showToast('缓存完成');
      }
    } catch (e) {
      EasyLoading.showToast('缓存失败');
    }
  }

  Future<ContentVo?> getContent(String type) async {
    if (type == '0') {
      _isLoading = true;
      BookData? bookData = await _bookDataProvider.get(_bid, _cid);
      if (bookData != null) {
        ContentVo contentVo = ContentVo.fromJson(bookData.toMap());
        return contentVo;
      }

      ContentVo? vo = await Api().content(_cid);
      if (vo != null) {
        BookData bd = BookData.fromMap(vo.toJson());
        await _bookDataProvider.insert(bd);
      }

      return vo;
    }
    String? cid;
    if (type == '1') {
      cid = await _bookDataProvider.prev(_bid, _contentVo!.cid!);
      cid ??= await Api().prev(_bid, _contentVo!.cid!);
    } else {
      cid = await _bookDataProvider.next(_bid, _contentVo!.cid!);
      cid ??= await Api().next(_bid, _contentVo!.cid!);
    }

    if (cid != null) {
      BookData? bookData = await _bookDataProvider.get(_bid, cid);
      if (bookData != null) {
        ContentVo contentVo = ContentVo.fromJson(bookData.toMap());
        return contentVo;
      }

      ContentVo? vo = await Api().content(cid);
      if (vo != null) {
        BookData bd = BookData.fromMap(vo.toJson());
        await _bookDataProvider.insert(bd);
      }

      return vo;
    }
    _isLoading = true;
    return null;
  }

  Future<List<String>> reCalculate(
      ContentVo contentVo, BuildContext context) async {
    _buildContext = context;
    await _initPadding(context);
    await _getWH(context);
    await _initTextPainter();
    return calculate(contentVo);
  }

  /// 文本分页计算方法
  List<String> calculate(ContentVo? contentVo) {
    List<String> texts = [];
    String? text =
        contentVo?.txt?.replaceAll('&nbsp;', '').replaceAll('<br>', '');
    int len = _textHeight! * _textWidth!;
    if (text != null && text.length < len) {
      texts.add(text);
    } else if (text != null) {
      int start = 0;
      int? end = _textWidth;
      loop:
      while (true) {
        String txt = '';
        for (int i = start; i < end!; i++) {
          String ckTxt = '';
          if (end >= text.length) {
            ckTxt = text.substring(start);
            txt = txt + ckTxt;
            texts.add(txt);
            break loop;
          } else {
            ckTxt = txt + text.substring(start, end);
          }
          if (_ckTxt(ckTxt)) {
            texts.add(txt);
            break;
          }
          txt = txt + text.substring(start, end);
          start = end;
          end = end + _textWidth!;
        }
      }
    }
    return texts;
  }

  ///检测是否超出页面范围
  bool _ckTxt(String txt) {
    textPainter.text = TextSpan(
        text: txt + _val,
        style: TextStyle(fontSize: getSize, height: getHeight));
    textPainter.layout(maxWidth: _pageWidth! - padding.horizontal);

    if (textPainter.didExceedMaxLines) {
      return true;
    }
    return false;
  }

  Future<EdgeInsetsGeometry> _initPadding(BuildContext buildContext) async {
    return padding = EdgeInsetsDirectional.only(
      start: getSae,
      end: getSae,
      top: 0,
      bottom: kBottomNavigationBarHeight,
    );
  }

  Future<void> _initTextPainter() async {
    textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      locale: PlatformDispatcher.instance.locale,
      maxLines: getTextHeight,
    );
  }

  void changSize(double fontSize) {
    _size = fontSize;
    Global.profile.fontSize = _size!;
    Global.saveProfile();
    notifyListeners();
  }

  void changHeight(double fontHeight) {
    _height = fontHeight;
    notifyListeners();
  }

  void changPadding(EdgeInsetsDirectional eid) {
    padding = eid;
  }

  /// 计算文本行数、行字数
  Future<void> _getWH(BuildContext context) async {
    _pageHeight = MediaQuery.of(context).size.height -
        kToolbarHeight -
        kBottomNavigationBarHeight -
        MediaQuery.of(context).padding.top * 2;

    _pageWidth = MediaQuery.of(context).size.width - padding.horizontal;

    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.justify,
        locale: PlatformDispatcher.instance.locale,
        text: TextSpan(
            text: _val, style: TextStyle(fontSize: getSize, height: getHeight)),
        maxLines: 1)
      ..layout(maxWidth: _pageWidth! - padding.horizontal);

    _textWidth = (_pageWidth! / textPainter.size.width).truncate();
    _textHeight = (_pageHeight! / textPainter.size.height).truncate();
  }
}
