import 'package:cached_network_image/cached_network_image.dart';
import 'package:edrb/models/book_detail_vo.dart';
import 'package:edrb/models/catalog_vo.dart';
import 'package:edrb/pages/content_page.dart';
import 'package:flutter/material.dart';

typedef CallBack = void Function();

GlobalKey<_BookInfoState> bookGlobalKey = GlobalKey();

class BookInfo extends StatefulWidget {
  const BookInfo({
    super.key,
    required this.callBack,
    required this.id,
    required this.detailVo,
  });

  final BookDetailVo? detailVo;
  final CallBack callBack;
  final String id;

  @override
  State<BookInfo> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  Widget _getItem(String imgUrl) {
    return CachedNetworkImage(
      height: 160,
      width: 110,
      imageUrl: imgUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      errorWidget: (context, url, error) =>
          const Icon(Icons.error, color: Colors.grey),
    );
  }

  List<Widget> _getWidget() {
    List<Widget> list = [
      Container(
        padding: const EdgeInsets.only(left: 18),
        child: _getItem(widget.detailVo!.bookVo!.cover!),
      ),
      Expanded(
        flex: 1,
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 2, bottom: 2),
                child: Text(
                  widget.detailVo!.bookVo!.name!,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 2, bottom: 2),
                child: Text(
                  widget.detailVo!.bookVo!.author!,
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 2, bottom: 2),
                child: Text(
                  widget.detailVo!.bookVo!.des!,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      )
    ];
    return list;
  }

  List<Widget> _catalogWidget() {
    List<Widget> list = [];
    for (CatalogVo catalog in widget.detailVo!.catalogVos!) {
      list.add(
        Container(
            width: 150,
            padding: const EdgeInsets.only(left: 18, right: 18),
            decoration: const BoxDecoration(
              border: BorderDirectional(
                end: BorderSide(color: Colors.grey, width: 0.1),
              ),
            ),
            child: InkWell(
              onTap: () => {
                Navigator.of(context).pushNamed(ContentPage.path, arguments: {
                  'bid': widget.id,
                  'cid': catalog.id,
                  'name': widget.detailVo?.bookVo?.name,
                })
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    catalog.name,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${catalog.createTime} 已更新',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )),
      );
    }

    list.add(
      Container(
          width: 150,
          padding: const EdgeInsets.only(left: 18, right: 18),
          decoration: const BoxDecoration(
            border: BorderDirectional(
              end: BorderSide(color: Colors.grey, width: 0.1),
            ),
          ),
          child: InkWell(
            onTap: () {
              widget.callBack();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '查看全部章节',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '共${widget.detailVo!.count}章',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )),
    );

    return list;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 18, bottom: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.detailVo != null ? _getWidget() : [],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                border: BorderDirectional(
                  top: BorderSide(color: Colors.grey, width: 0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: widget.detailVo != null ? _catalogWidget() : [],
              ),
            ),
          )
        ],
      ),
    );
  }
}
