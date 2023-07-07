import 'package:edrb/common/Api.dart';
import 'package:edrb/models/catalog_vo.dart';
import 'package:edrb/widgets/Search.dart';
import 'package:flutter/material.dart';

typedef CallBack = void Function(String cid);

class CatalogSheet extends StatefulWidget {
  const CatalogSheet({
    super.key,
    required this.callBack,
    required this.id,
    this.backColor,
    this.fontColor,
  });

  final CallBack callBack;
  final String id;
  final Color? backColor;
  final Color? fontColor;

  @override
  State<CatalogSheet> createState() => _CatalogSheetState();
}

class _CatalogSheetState extends State<CatalogSheet> {
  int pageNum = 1;
  int _count = 0;
  late String? _val = '';
  late List<CatalogVo> _catalogList = [];

  @override
  void initState() {
    super.initState();
    _findList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _findList() async {
    Map<String, Object> data = {
      'val': _val!,
      'bid': widget.id,
      'pageNum': pageNum,
      'pageSize': 20
    };
    List<CatalogVo> list = await Api().catalogList(data);
    if (list.isNotEmpty) {
      setState(() {
        pageNum++;
        _catalogList.addAll(list);
        _count = _catalogList.length;
      });
    }
  }

  void _onSearch(String val) {
    _reset(val);
    _findList();
  }

  void _reset(String val) {
    setState(() {
      _count = 0;
      _val = val;
      pageNum = 1;
      _catalogList = [];
    });
  }

  void _onClear() {
    _reset('');
    _findList();
  }

  Widget _getCatalog(BuildContext context, int index) {
    CatalogVo catalogVo = _catalogList[index];
    return InkWell(
      onTap: () {
        widget.callBack(catalogVo.id);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 14, bottom: 14),
        decoration: const BoxDecoration(
            border: BorderDirectional(
          top: BorderSide(color: Colors.grey, width: 0.1),
        )),
        child: Text(
          catalogVo.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(color: widget.fontColor ?? Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.backColor ?? Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      height: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Search(
            width: 30,
            height: 40,
            hintText: '搜索目录',
            onSearch: (val) => _onSearch(val),
            onClear: () => {_onClear()},
          ),
          SizedBox(
            height: 520,
            child: ListView.builder(
              itemCount: _count,
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 5, right: 5),
              itemBuilder: (BuildContext context, int index) {
                if (index + 1 == _count) {
                  _findList();
                }
                return _getCatalog(context, index);
              },
            ),
          )
        ],
      ),
    );
  }
}
