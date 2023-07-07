import 'package:edrb/common/Api.dart';
import 'package:edrb/models/content_vo.dart';
import 'package:edrb/pages/content_page.dart';
import 'package:flutter/material.dart';

typedef CallBack = void Function(Map<String, String> map);

class BottomBtn extends StatefulWidget {
  const BottomBtn({
    super.key,
    required this.callBack,
    required this.id,
    required this.status,
    required this.name,
  });

  final CallBack callBack;
  final String id;
  final bool? status;
  final String? name;

  @override
  State<BottomBtn> createState() => _BottomBtnState();
}

class _BottomBtnState extends State<BottomBtn> {
  late bool _status = false;
  late String? _cid = null;

  @override
  void initState() {
    super.initState();
    setState(() {
      _status = widget.status!;
    });
    _getFirst();
  }

  void _getFirst() async {
    String? cid = await Api().start(widget.id);
    if (cid != null) {
      setState(() {
        _cid = cid;
      });
    }
  }

  void _addShelf(BuildContext context) async {
    int res = await Api(context).addShelf(widget.id);
    if (res == 0) {
      setState(() {
        _status = true;
      });
    }
  }

  void _start(BuildContext context) async {
    if (_cid == null) {
      _getFirst();
      return;
    }
    Navigator.of(context).pushNamed(ContentPage.path, arguments: {
      'bid': widget.id,
      'cid': _cid,
      'name': widget.name,
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      padding: const EdgeInsets.only(top: 5, bottom: 8),
      child: Visibility(
        visible: _cid != null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _addShelf(context),
                child: Container(
                  alignment: Alignment.center,
                  height: 42,
                  margin: const EdgeInsets.only(left: 18, right: 5, top: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200),
                  child: !_status ?? false
                      ? const Text(
                          "加入书架",
                          style: TextStyle(
                              letterSpacing: 2, fontWeight: FontWeight.w500),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_sharp,
                              size: 20,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "已加入",
                              style: TextStyle(
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _start(context),
                child: Container(
                  alignment: Alignment.center,
                  height: 42,
                  margin: const EdgeInsets.only(left: 5, right: 18, top: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue),
                  child: const Text(
                    "阅读",
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
