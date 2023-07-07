import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/common/Api.dart';
import 'package:edrb/models/book_rate_vo.dart';
import 'package:edrb/models/rate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';

typedef CallBack = void Function(String val);

GlobalKey<_RecommendState> recommendGlobalKey = GlobalKey();

class Recommend extends StatefulWidget {
  const Recommend({
    super.key,
    required this.callBack,
    required this.id,
  });

  final CallBack callBack;
  final String id;

  @override
  State<Recommend> createState() => _RecommendState();
}

class _RecommendState extends State<Recommend> {
  late Rate? _rate = Rate();
  final List<String> _list = [
    'assets/book/bbby60.png',
    'assets/book/zdyd70.png',
    'assets/book/kzrk80.png',
    'assets/book/hprc85.png',
    'assets/book/sz90.png',
  ];

  late final List<BookRateVo> _rateList = [];

  @override
  void initState() {
    super.initState();
    _getRate();
    _getRateList();
  }

  int pageNum = 1;
  int pageSize = 5;

  void _getRateList() async {
    Map<String, Object> data = {
      'bid': widget.id,
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
    List<BookRateVo> list = await Api().rateList(data);
    if (list.isNotEmpty) {
      setState(() {
        _rateList.addAll(list);
        pageNum++;
      });
    } else {
      EasyLoading.showToast('没有更多数据');
    }
  }

  void _loadMore(BuildContext context) {
    GFToast.showToast(
      '没有数据了',
      context,
      toastPosition: GFToastPosition.CENTER,
      textStyle: const TextStyle(fontSize: 16, color: GFColors.LIGHT),
      backgroundColor: GFColors.DARK,
    );
  }

  Widget _getAvatar(String? url) {
    if (null == url) {
      return Image.asset('assets/avatar1.png',height: 26,width: 26,);
    }
    return CachedNetworkImage(
      height: 26,
      width: 26,
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      errorWidget: (context, url, error) =>
          const Icon(Icons.error, color: Colors.grey),
    );
  }

  String _replaceTxt(String rate) {
    if (rate == '2') {
      return '一般';
    }
    if (rate == '3') {
      return '不行';
    }
    return "推荐";
  }

  Widget _getIcon(String rate) {
    IconData data = Icons.sunny;
    if (rate == '2') {
      data = Icons.sunny;
    }
    if (rate == '3') {
      data = Icons.cloudy_snowing;
    }
    return Icon(
      data,
      size: 14,
      color: Colors.grey,
    );
  }

  void _getRate() async {
    Rate? rate = await Api().calculate(widget.id);
    if (null != rate) {
      setState(() {
        _rate = rate;
      });
    }
  }

  List<Widget> _getListRate() {
    List<Widget> list = [];

    if(_rateList.isNotEmpty){
      list.add(
        Container(
          color: Colors.white,
          width: double.maxFinite,
          padding:
          const EdgeInsets.only(top: 14, bottom: 14, left: 18, right: 18),
          child: const Text("最新点评",
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 1)),
        ),
      );
    }


    for (BookRateVo rateVo in _rateList) {
      list.add(
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(top: 6, bottom: 6, left: 18, right: 18),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _getAvatar(rateVo.userVo!.avatarUrl),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    rateVo.userVo!.nickName!,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  _getIcon(rateVo.rate!),
                  Text(
                    _replaceTxt(rateVo.rate!),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  rateVo.comments!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              )
            ],
          ),
        ),
      );
    }
    return list;
  }

  void setRate(String id) async {
    BookRateVo? bookRateVo = await Api().getRate(id);
    if (bookRateVo != null) {
      setState(() {
        _rateList.insert(0, bookRateVo);
      });
    }
  }

  Widget _getImg(double rate) {
    String img = '';
    if (rate <= 60) {
      img = _list[0];
    } else if (rate > 60 && rate <= 70) {
      img = _list[1];
    } else if (rate > 70 && rate <= 80) {
      img = _list[2];
    } else if (rate > 80 && rate <= 85) {
      img = _list[3];
    } else if (rate > 85) {
      img = _list[4];
    }

    return Image.asset(
      img,
      fit: BoxFit.cover,
      height: 30,
    );
  }

  List<Widget> _getProgress() {
    List<Widget> widgets = [];
    for (int i = 0; i < 3; i++) {
      String txt = '推荐';
      double? n = 0;
      if (i == 0) {
        n = _rate?.r1 ?? 0;
      } else if (i == 1) {
        n = _rate?.r2 ?? 0;
        txt = '一般';
      } else if (i == 2) {
        n = _rate?.r3 ?? 0;
        txt = '不行';
      }
      if (n != 0) {
        n = n / 100;
      }

      widgets.add(GFProgressBar(
        percentage: n,
        lineHeight: 5,
        alignment: MainAxisAlignment.spaceBetween,
        leading: Text(
          txt,
          style: const TextStyle(
              fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black26,
        progressBarColor: Colors.black54,
      ));
    }

    return widgets;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            width: double.maxFinite,
            padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
            child: Text(
              _rate == null ? '' : '用户读书推荐率${_rate?.r1 ?? ''}%',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.only(left: 18, right: 18, top: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 5, right: 5),
                        child: _getImg(_rate?.r1 ?? 0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              "${_rate?.count ?? 0}人点评",
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right,
                            size: 19,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _getProgress(),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 6, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(left: 18, right: 0),
                    decoration: const BoxDecoration(
                        border: BorderDirectional(
                            top: BorderSide(color: Colors.grey, width: 0.2))),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "我要点评此书",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(left: 0, right: 18),
                    decoration: const BoxDecoration(
                        border: BorderDirectional(
                            top: BorderSide(color: Colors.grey, width: 0.2))),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: 42,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200),
                    child: InkWell(
                      onTap: () => {widget.callBack('1')},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sunny,
                            color: Colors.grey,
                            size: 18,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "推荐",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: 42,
                    margin: const EdgeInsets.only(right: 5, left: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200),
                    child: InkWell(
                      onTap: () => {widget.callBack('2')},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud,
                            color: Colors.grey,
                            size: 18,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "一般",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: 42,
                    margin: const EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200),
                    child: InkWell(
                      onTap: () => {widget.callBack('3')},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloudy_snowing,
                            color: Colors.grey,
                            size: 18,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "不行",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getListRate(),
            ),
          ),
          Visibility(
            visible: _rateList.isNotEmpty,
            child: GestureDetector(
              onTap: () => _getRateList(),
              child: Container(
                alignment: Alignment.center,
                height: 42,
                margin: const EdgeInsets.only(left: 18, right: 18, top: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200),
                child: Text(
                  '查看更多点评',
                  style: TextStyle(
                      fontSize: 13,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
