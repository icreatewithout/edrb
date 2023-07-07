import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/book_rate_vo.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyRateListPage extends StatefulWidget {
  static const String path = "/my/rate";
  final Map? arguments;

  const MyRateListPage({super.key, required this.arguments});

  @override
  State<MyRateListPage> createState() => _MyRateListPageState();
}

class _MyRateListPageState extends State<MyRateListPage> {
  late final List<BookRateVo> _rateList = [];

  @override
  void initState() {
    _getRateList();
    super.initState();
  }

  int pageNum = 1;
  int pageSize = 10;
  bool haveNext = true;

  void _getRateList() async {
    Map<String, Object> data = {
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
    List<BookRateVo> list = await Api().myRateList(data);
    if (list.isNotEmpty && haveNext) {
      setState(() {
        _rateList.addAll(list);
        pageNum++;
        haveNext = true;
      });
    } else {
      setState(() {
        haveNext = false;
      });
    }
  }

  void _del(String id, int index, BuildContext context) async {
    int i = await Api().delRate(id);
    if (i > 0) {
      setState(() {
        _rateList.removeAt(index);
      });
      Navigator.of(context).pop();
    } else {
      EasyLoading.showToast('删除失败');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _rate(BuildContext context, int index) {
    BookRateVo vo = _rateList[index];
    return GestureDetector(
        onLongPress: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  alignment: Alignment.center,
                  title: const Text(
                    "删除点评",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  content: const Text(
                    "确定删除该点评吗",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  actions: [
                    TextButton(
                      child: const Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop(); // 关闭弹框
                      },
                    ),
                    TextButton(
                      child: const Text("确定",
                          style: TextStyle(color: Colors.redAccent)),
                      onPressed: () => _del(vo.id!, index, context),
                    ),
                  ],
                );
              },
            ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vo.comments!),
                  const SizedBox(height: 10),
                  _oneBook(vo.book!),
                ],
              ),
            ),
            Positioned(
              right: 40,
              top: 20,
              child: Text(
                vo.time!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            )
          ],
        ));
  }

  Widget _oneBook(BookVo vo) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          BookDetailPage.path,
          arguments: {'title': '详情', 'name': vo.name, 'id': vo.id},
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              height: 66,
              width: 50,
              imageUrl: vo.cover!,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: Colors.grey),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vo.name!),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    vo.des!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        centerTitle: true,
        title: const Text(
          '管理我的点评',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _rateList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index + 1 == _rateList.length && haveNext) {
            _getRateList();
          }
          return _rate(context, index);
        },
      ),
    );
  }
}
