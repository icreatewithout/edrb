import 'package:edrb/common/Api.dart';
import 'package:edrb/models/book_detail_vo.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/widgets/detail/BookInfo.dart';
import 'package:edrb/widgets/detail/BottomBtn.dart';
import 'package:edrb/widgets/detail/CatalogSheet.dart';
import 'package:edrb/widgets/detail/RateSheet.dart';
import 'package:edrb/widgets/detail/Recommend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'content_page.dart';

class BookDetailPage extends StatefulWidget {
  static const String path = "/detail";
  final Map arguments;

  const BookDetailPage({super.key, required this.arguments});

  @override
  State<BookDetailPage> createState() => _BookDetailPage();
}

class _BookDetailPage extends State<BookDetailPage> {
  final GlobalKey<_BookDetailPage> _scaffoldKey = GlobalKey<_BookDetailPage>();

  late String _id;
  late BookDetailVo? _detailVo = null;
  late BookVo? _bookVo = null;
  bool show = false;

  @override
  void initState() {
    _getInfo(widget.arguments['id']);
    super.initState();
    setState(() {
      _id = widget.arguments['id'];
    });
  }

  void _getInfo(id) async {
    BookDetailVo detailVo = await Api().bookDetail(id);
    setState(() {
      _detailVo = detailVo;
      _bookVo = detailVo.bookVo;
      show = true;
    });
  }

  void _openSheet(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CatalogSheet(
          callBack: (cid) => {
            Navigator.of(context).pushNamed(ContentPage.path, arguments: {
              'bid': _id,
              'cid': cid,
              'name': _detailVo?.bookVo?.name,
            })
          },
          id: _id,
        );
      },
    );
  }

  void _openRateView(String val) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AnimatedPadding(
          padding: EdgeInsets.only(
            // 下面这一行是重点
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          duration: Duration.zero,
          child: SingleChildScrollView(
            child: RateSheet(
              callBack: (id) => _setRate(id),
              id: _id,
              name: _detailVo!.bookVo!.name!,
              val: val,
            ),
          ),
        );
      },
    );
  }

  void _setRate(id) {
    recommendGlobalKey.currentState?.setRate(id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
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
        title: Container(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.arguments['name'],
                style: const TextStyle(color: Colors.black87, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookInfo(
                key: bookGlobalKey,
                callBack: () => _openSheet(context),
                id: _id,
                detailVo: _detailVo,
              ),
              Visibility(
                visible: show,
                child: Recommend(
                  key: recommendGlobalKey,
                  callBack: (val) => _openRateView(val),
                  id: _id,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: _detailVo != null && _bookVo != null,
        child: BottomBtn(
          callBack: (map) => {},
          id: _id,
          status: _detailVo?.shelf,
          name: _bookVo?.name,
        ),
      ),
    );
  }
}
