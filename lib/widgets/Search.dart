import 'package:flutter/material.dart';

/// 搜索AppBar
class Search extends StatefulWidget {
  const Search({
    Key? key,
    this.borderRadius = 10,
    this.autoFocus = false,
    this.focusNode,
    this.controller,
    this.height = 40,
    this.width = 30,
    this.value,
    this.prefix,
    this.backgroundColor,
    this.suffix,
    this.hintText,
    this.onTap,
    this.onClear,
    this.onCancel,
    this.onChanged,
    this.onSearch,
    this.onRightTap,
  }) : super(key: key);
  final double? borderRadius;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  // 输入框高度 默认40
  final double height;

  // 输入框高度 默认30
  final double width;

  // 默认值
  final String? value;

  // 最前面的组件
  final Widget? prefix;

  // 背景色
  final Color? backgroundColor;

  // 搜索框内部后缀组件
  final Widget? suffix;

  // 输入框提示文字
  final String? hintText;

  // 输入框点击回调
  final VoidCallback? onTap;

  // 清除输入框内容回调
  final VoidCallback? onClear;

  // 清除输入框内容并取消输入
  final VoidCallback? onCancel;

  // 输入框内容改变
  final ValueChanged<String>? onChanged;

  // 点击键盘搜索
  final ValueChanged<String>? onSearch;

  // 点击右边widget
  final VoidCallback? onRightTap;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController? _controller;
  FocusNode? _focusNode;

  bool get isFocus => _focusNode?.hasFocus ?? false; //是否获取焦点

  bool get isTextEmpty => _controller?.text.isEmpty ?? false; //输入框是否为空

  bool isShowCancel = false;

  get height => widget.height;

  get hintText => widget.hintText;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    if (widget.value != null) _controller?.text = widget.value ?? "";
    // 焦点获取失去监听
    _focusNode?.addListener(() => setState(() {}));
    // 文本输入监听
    _controller?.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  // 清除输入框内容
  void _onClearInput() {
    setState(() {
      _controller?.clear();
      _focusNode?.unfocus(); //失去焦点
    });
    widget.onClear!();
  }

  void _toScan() {
    widget.onRightTap!();
  }

  // 取消输入框编辑失去焦点
  void _onCancelInput() {
    setState(() {
      _controller?.clear();
      _focusNode?.unfocus(); //失去焦点
    });
    // 执行onCancel
    widget.onCancel?.call();
  }

  Widget _suffix() {
    if (!isTextEmpty) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: InkWell(
          onTap: _onClearInput,
          child: const Center(
            child: Icon(
              Icons.close_outlined,
              size: 20,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }
    return widget.suffix != null
        ? SizedBox(
            width: widget.width,
            height: widget.height,
            child: InkWell(
              onTap: _toScan,
              child: widget.suffix,
            ),
          )
        : const SizedBox();
  }

  Widget _prefix() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: const Center(
        child: Icon(
          Icons.search_outlined,
          size: 20,
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.maxFinite,
      height: 40,
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _prefix(),
          Expanded(
            flex: 1,
            child: TextField(
              autofocus: false,
              focusNode: _focusNode,
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText,
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              style: const TextStyle(fontSize: 16),
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.text,
              onTap: widget.onTap,
              // 输入框内容改变回调
              onChanged: widget.onChanged,
              onSubmitted: widget.onSearch,
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
          _suffix(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _focusNode?.dispose();
    super.dispose();
  }
}
