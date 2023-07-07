import 'package:edrb/models/book_vo.dart';
import 'package:edrb/models/user_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_re_view.g.dart';

@JsonSerializable()
class BookReView {
  BookReView();

  String? id;

  String? title;

  String? des;

  String? type;

  String? time;

  UserVo? user;

  List<BookVo>? books;

  factory BookReView.fromJson(Map<String, dynamic> json) =>
      _$BookReViewFromJson(json);

  Map<String, dynamic> toJson() => _$BookReViewToJson(this);
}
