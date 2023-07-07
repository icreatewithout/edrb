import 'package:edrb/common/Api.dart';
import 'package:edrb/models/book_forum.dart';
import 'package:edrb/models/book_list_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef CallBack = void Function(String? parentid, String id);

GlobalKey<_ForumCommentBottomBarState> forumCommentBottomBarGlobalKey = GlobalKey();

class ForumCommentBottomBar extends StatefulWidget {
  const ForumCommentBottomBar({
    super.key,
    required this.callBack,
    required this.id,
    required this.forum,
  });

  final CallBack callBack;
  final String id;
  final BookForum forum;

  @override
  State<ForumCommentBottomBar> createState() => _ForumCommentBottomBarState();
}

class _ForumCommentBottomBarState extends State<ForumCommentBottomBar> {
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
    bool b = await Api(context).likeBookForum(widget.id);

    int i = widget.forum.like!;
    if (b) {
      i++;
    } else {
      i--;
    }
    setState(() {
      widget.forum.thumb = b;
      widget.forum.like = i;
    });
  }

  void _sub(BuildContext context) async {
    if (_controller1.text.isEmpty) {
      return EasyLoading.showToast('请输入评论内容');
    }

    Map<String, Object> data = {
      'prentId': _prentId ?? 0,
      'replayUid': _replayId ?? 0,
      'bfId': widget.id,
      'des': _controller1.text,
    };
    String? id = await Api(context).saveForumComment(data);
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
        widget.forum.comment = widget.forum.comment! + 1;
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
                        '${widget.forum.comment == null || widget.forum.comment == 0 ? '' : widget.forum.comment}'),
                  ],
                )),
            GestureDetector(
              onTap: () => _thumbUp(context),
              child: Row(
                children: [
                  Icon(
                    Icons.thumb_up_alt_outlined,
                    color:
                        widget.forum.thumb != null && widget.forum.thumb == true
                            ? Colors.redAccent
                            : Colors.grey,
                  ),
                  const SizedBox(width: 2),
                  Text(
                      '${widget.forum.like == null || widget.forum.like == 0 ? '' : widget.forum.like}'),
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
