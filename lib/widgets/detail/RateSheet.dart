import 'package:edrb/common/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef CallBack = void Function(String id);

class RateSheet extends StatefulWidget {
  const RateSheet({
    super.key,
    required this.callBack,
    required this.id,
    required this.name,
    required this.val,
  });

  final CallBack callBack;
  final String id;
  final String name;
  final String val;

  @override
  State<RateSheet> createState() => _RateSheetState();
}

class _RateSheetState extends State<RateSheet> {
  late final TextEditingController _controller = TextEditingController();
  late String _val = widget.val;

  late String _select = widget.val;

  final Color _unSelectColor = Colors.grey.shade200;
  final Color _selectColor = Colors.blue;

  final Color _unSelectTxtColor = Colors.grey;
  final Color _selectTxtColor = Colors.white;

  void _changeSelect(String val) {
    setState(() {
      _val = val;
      _select = val;
    });
  }

  void _submitRate(BuildContext context) async {
    if (_controller.text.isEmpty) {
      return EasyLoading.showToast('请输入点评内容',
          toastPosition: EasyLoadingToastPosition.top);
    }
    EasyLoading.show(status: '正在提交');
    Map<String, Object> data = {
      'bid': widget.id,
      'rate': _val,
      'comments': _controller.text,
    };
    String? id = await Api(context).saveRate(data);
    if (id == null) {
      EasyLoading.dismiss();
      return EasyLoading.showToast('点评失败请重试',
          toastPosition: EasyLoadingToastPosition.top);
    }
    widget.callBack(id);
    Navigator.of(context).pop();
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        '点评《${widget.name}》',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () => _submitRate(context),
                      child: Container(
                        padding: const EdgeInsets.only(left: 5, right: 2),
                        child: const Text(
                          '发布',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  border: BorderDirectional(
                      bottom: BorderSide(color: Colors.grey, width: 0.2))),
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
                          color:
                              _select == '1' ? _selectColor : _unSelectColor),
                      child: InkWell(
                        onTap: () => _changeSelect('1'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.sunny,
                                color: _select == '1'
                                    ? _selectTxtColor
                                    : _unSelectTxtColor,
                                size: 18),
                            const SizedBox(width: 2),
                            Text("推荐",
                                style: TextStyle(
                                    color: _select == '1'
                                        ? _selectTxtColor
                                        : _unSelectTxtColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold))
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
                          color:
                              _select == '2' ? _selectColor : _unSelectColor),
                      child: InkWell(
                        onTap: () => _changeSelect('2'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud,
                                color: _select == '2'
                                    ? _selectTxtColor
                                    : _unSelectTxtColor,
                                size: 18),
                            const SizedBox(width: 2),
                            Text(
                              "一般",
                              style: TextStyle(
                                  color: _select == '2'
                                      ? _selectTxtColor
                                      : _unSelectTxtColor,
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
                          color:
                              _select == '3' ? _selectColor : _unSelectColor),
                      child: InkWell(
                        onTap: () => _changeSelect('3'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.cloudy_snowing,
                                color: _select == '3'
                                    ? _selectTxtColor
                                    : _unSelectTxtColor,
                                size: 18),
                            const SizedBox(width: 2),
                            Text("不行",
                                style: TextStyle(
                                    color: _select == '3'
                                        ? _selectTxtColor
                                        : _unSelectTxtColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 20),
              child: TextField(
                maxLines: 10,
                maxLength: 1000,
                controller: _controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  isDense: true,
                  hintText: '点评这本书...',
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                onEditingComplete: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  /// 键盘是否是弹起状态,弹出且输入完成时收起键盘
                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus!.unfocus();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
