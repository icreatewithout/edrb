import 'package:edrb/common/Api.dart';
import 'package:edrb/models/book_list_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef CallBack = void Function(String? parentid, String id);

GlobalKey<_CommentBottomBarState> commentBottomBarGlobalKey = GlobalKey();

class CommentBottomBar extends StatefulWidget {
  const CommentBottomBar({
    super.key,
    required this.callBack,
    required this.id,
    required this.count,
  });

  final CallBack callBack;
  final String id;
  final BookListCount count;

  @override
  State<CommentBottomBar> createState() => _CommentBottomBarState();
}

class _CommentBottomBarState extends State<CommentBottomBar> {
  final TextEditingController _controller1 = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late String type = '1';
  late String? _replayId = null;
  late String? _prentId = null;
  String _name = '发表评论...';

  bool get isTextEmpty => _controller1.text.isEmpty; //输入框是否为空
  @override
  void initState() {
    // 焦点获取失去监听
    _focusNode.addListener(() => setState(() {}));
    // 文本输入监听
    _controller1.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
  }

  void _thumbUp(BuildContext context) async {
    bool b = await Api(context).likeBookList(widget.id);

    int i = widget.count.count!;
    if (b) {
      i++;
    } else {
      i--;
    }
    setState(() {
      widget.count.thumb = b;
      widget.count.count = i;
    });
  }

  void _sub(BuildContext context) async {
    if (_controller1.text.isEmpty) {
      return EasyLoading.showToast('请输入评论内容');
    }

    Map<String, Object> data = {
      'prentId': _prentId ?? 0,
      'replayUid': _replayId ?? 0,
      'blId': widget.id,
      'des': _controller1.text,
    };
    String? id = await Api(context).saveComment(data);
    if (id != null) {
      EasyLoading.showToast('评论成功');
      FocusScope.of(context).unfocus();
      widget.callBack(_prentId, id);
      setState(() {
        type = '1';
        _controller1.clear();
        _name = '发表评论...';
        _replayId = null;
        _prentId = null;
        widget.count.comment = widget.count.comment! + 1;
      });
    } else {
      EasyLoading.showToast('评论失败');
    }
  }

  void setId(String prentId, String name, String replayId) {
    setState(() {
      _prentId = prentId;
      _replayId = replayId;
      _name = '回复$name';
      _openKeyboard();
    });
  }

  void _openKeyboard() {
    SystemChannels.textInput.invokeMethod<void>('TextInput.show');
    FocusScope.of(context).requestFocus(_focusNode);
    setState(() {
      type = '2';
    });
  }

  Widget _getRightWidget() {
    if (type == '1') {
      return Expanded(
        flex: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
                onTap: () => _openKeyboard(),
                child: Row(
                  children: [
                    const Icon(
                      Icons.comment_bank_outlined,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 2),
                    Text(
                        '${widget.count.comment == null || widget.count.comment == 0 ? '' : widget.count.comment}'),
                  ],
                )),
            GestureDetector(
              onTap: () => _thumbUp(context),
              child: Row(
                children: [
                  Icon(
                    Icons.thumb_up_alt_outlined,
                    color:
                        widget.count.thumb != null && widget.count.thumb == true
                            ? Colors.redAccent
                            : Colors.grey,
                  ),
                  const SizedBox(width: 2),
                  Text(
                      '${widget.count.count == null || widget.count.count == 0 ? '' : widget.count.count}'),
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 10),
        child: GestureDetector(
          onTap: () => _sub(context),
          child: const Text('发表', style: TextStyle(color: Colors.blue)),
        ),
      );
    }
  }

  Widget _suffix() {
    if (!isTextEmpty) {
      return SizedBox(
        child: InkWell(
          onTap: () => setState(() {
            type = '1';
            _name = '发表评论...';
            _prentId = null;
            _replayId = null;
            _controller1.clear();
          }),
          child: const Center(
            child: Icon(
              Icons.cancel_rounded,
              size: 18,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      padding: const EdgeInsets.only(
        left: 18,
        right: 18,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade200,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _controller1,
                        maxLength: 50,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            isDense: true,
                            hintText: _name,
                            counterText: '',
                            hintStyle: const TextStyle(
                                fontSize: 14, color: Colors.grey)),
                        style: const TextStyle(fontSize: 14),
                        textInputAction: TextInputAction.done,
                        onTap: () => setState(() {
                          type = '2';
                        }),
                        onSubmitted: (val) => setState(() {
                          type = '2';
                        }),
                        onEditingComplete: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus &&
                              currentFocus.focusedChild != null) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          }
                        },
                      ),
                    ),
                    _suffix(),
                  ],
                )),
          ),
          _getRightWidget(),
        ],
      ),
    );
  }
}
