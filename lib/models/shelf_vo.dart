import 'package:json_annotation/json_annotation.dart';

import 'book_vo.dart';

part 'shelf_vo.g.dart';

@JsonSerializable()
class ShelfVo {
  ShelfVo();

  String? id;

  String? uid;

  String? bid;

  String? cid;

  BookVo? bookVo;

  bool? select = false;

  factory ShelfVo.fromJson(Map<String, dynamic> json) =>
      _$ShelfVoFromJson(json);

  Map<String, dynamic> toJson() => _$ShelfVoToJson(this);
}
