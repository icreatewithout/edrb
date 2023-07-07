import 'package:edrb/models/book_vo.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user_vo.dart';

part 'book_list_vo.g.dart';

@JsonSerializable()
class BookListVo {
  BookListVo();

  String? id;

  UserVo? userVo;

  String? title;

  String? des;

  List<BookVo>? books;

  String? status;

  String? time;

  factory BookListVo.fromJson(Map<String, dynamic> json) =>
      _$BookListVoFromJson(json);

  Map<String, dynamic> toJson() => _$BookListVoToJson(this);
}
