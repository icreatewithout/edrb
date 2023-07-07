import 'package:edrb/models/book_vo.dart';
import 'package:edrb/models/user_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_forum.g.dart';

@JsonSerializable()
class BookForum {
  BookForum();

  String? id;

  UserVo? userVo;

  String? des;

  String? type;

  List<String>? pictures;

  List<BookVo>? books;

  List<String>? tags;

  String? time;

  int? comment = 0;

  int? like = 0;

  bool? thumb;

  factory BookForum.fromJson(Map<String, dynamic> json) =>
      _$BookForumFromJson(json);

  Map<String, dynamic> toJson() => _$BookForumToJson(this);
}
