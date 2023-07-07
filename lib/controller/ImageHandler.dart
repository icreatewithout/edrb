import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef CallBack<int> = void Function(int index);
typedef SelectCallBack = void Function();

class ImageHandler {
  late List<XFile> images = [];
  final ImagePicker picker = ImagePicker();

  XFile? xFile;

  XFile? get getXFile => xFile;
  final CallBack? del;
  final SelectCallBack? select;

  ImageHandler({
    this.del,
    this.select,
  });

  Future<XFile?> selectPicture() async {
    XFile? file =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    return file;
  }

  Widget showPicture(List<XFile> list) {
    Container container = Container(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, //横轴三个子widget
          childAspectRatio: 1, //宽高比为1时，子widget
          crossAxisSpacing: 18.0,
          mainAxisSpacing: 18.0,
        ),
        children: _images(list),
      ),
    );

    return container;
  }

  List<Widget> _images(List<XFile> xFiles) {
    List<Widget> list = [];
    for (int i = 0; i < xFiles.length; i++) {
      list.add(
        Stack(
          children: [
            Image.file(
              File(xFiles[i].path),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => del!(i),
                child: const Icon(
                  Icons.close,
                  color: Colors.redAccent,
                ),
              ),
            )
          ],
        ),
      );
    }
    if (list.isNotEmpty && list.length < 9) {
      list.add(
        GestureDetector(
          onTap: () => select!(),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 0.1, color: Colors.grey)),
            child: const Center(
              child: Icon(Icons.add, color: Colors.grey, size: 40),
            ),
          ),
        ),
      );
    }
    return list;
  }
}
