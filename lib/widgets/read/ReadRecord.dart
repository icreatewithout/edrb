import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/models/record_vo.dart';
import 'package:edrb/models/shelf_vo.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:edrb/pages/content_page.dart';
import 'package:edrb/states/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadRecord extends StatefulWidget {
  const ReadRecord({super.key});

  @override
  State<ReadRecord> createState() => _ReadRecord();
}

class _ReadRecord extends State<ReadRecord> {
  late List<Record> _list = [];
  late int day = 0;
  late String readTxt = '继续阅读';
  late int readTimeH = 0;
  late int readTimeM = 0;
  late int readTimeS = 0;

  @override
  void initState() {
    super.initState();
    _init();
    _read();
    _readTime();
  }

  void _readTime() async {
    Map<String, dynamic>? res = await Api().readTime();
    print(res);
    if (res != null) {
      setState(() {
        readTimeH = res['h']!;
        readTimeM = res['m']!;
        readTimeS = res['s']!;
      });
    }
  }

  void _init() async {
    List<Record> list = await Api(context).recordList();
    if (list.isNotEmpty) {
      setState(() {
        _list = list;
      });
    } else {
      setState(() {
        readTxt = '还没有记录';
      });
    }
  }

  void _read() async {
    int i = await Api().readDay();
    setState(() {
      day = i;
    });
  }

  final EdgeInsets _margin = const EdgeInsets.only(right: 10);

  final BoxDecoration _boxDecoration =
      const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)));

  Widget _getItem(String bid, String cid, String imgUrl, String name) {
    return Container(
      margin: _margin,
      decoration: _boxDecoration,
      height: 90,
      width: 70,
      child: InkWell(
        onTap: () => {
          if (cid.isEmpty)
            {
              Navigator.of(context).pushNamed(
                BookDetailPage.path,
                arguments: {'title': '详情', 'name': name, 'id': bid},
              )
            }
          else
            {
              Navigator.of(context).pushNamed(ContentPage.path, arguments: {
                'bid': bid,
                'cid': cid,
                'name': name,
              })
            }
        },
        child: Center(
          child: CachedNetworkImage(
            imageUrl: imgUrl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _children(BuildContext context) {
    List<Widget> list = [];

    list.add(_firstWidget(context));

    for (var record in _list) {
      list.add(_getItem(
        record.bid!,
        record.cid ?? '',
        record.cover!,
        record.name!,
      ));
    }
    return list;
  }

  Widget _firstWidget(BuildContext context) {
    return Container(
      margin: _margin,
      decoration: _boxDecoration,
      height: 90,
      width: 120,
      child: InkWell(child: _goOnWidget(context), onTap: () => {}),
    );
  }

  List<Text> _format() {
    List<Text> list = [];

    if (readTimeH < 1 && readTimeM < 1) {
      return [
        Text('$readTimeS'),
        const Text('秒', style: TextStyle(fontSize: 10)),
      ];
    }

    if (readTimeH == 0 && readTimeM > 0) {
      return [
        Text('$readTimeM'),
        const Text('分钟', style: TextStyle(fontSize: 10)),
      ];
    }

    if (readTimeH > 0 && readTimeM > 0) {
      return [
        Text('$readTimeH'),
        const Text('小时', style: TextStyle(fontSize: 10)),
        Text('$readTimeM'),
        const Text('分钟', style: TextStyle(fontSize: 10)),
      ];
    }

    list.add(const Text(
      '无记录',
      style: TextStyle(color: Colors.grey),
    ));
    return list;
  }

  void toRead(BuildContext context) {
    if (_list.isEmpty) {
      return;
    }

    Record record = _list[0];
    Navigator.of(context).pushNamed(ContentPage.path, arguments: {
      'bid': record.bid,
      'cid': record.cid,
      'name': record.name,
    });
  }

  Widget _goOnWidget(BuildContext context) {
    return GestureDetector(
      onTap: () => toRead(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 12,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      '本周阅读$day天',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                Row(
                  children: _format(),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: Text(
                readTxt,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget? child) {
        return Visibility(
          visible: userModel.isLogin,
          child: Container(
            padding: const EdgeInsets.only(top: 16, left: 18, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _children(context),
            ),
          ),
        );
      },
    );
  }
}
