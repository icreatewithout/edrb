import 'package:edrb/models/user_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_list_comment_vo.g.dart';

@JsonSerializable()
class BookListCommentVo {
  BookListCommentVo();

  String? prentId;

  String? id;

  String? blId;

  UserVo? user;
  UserVo? replayUser;

  String? time;

  String? des;

  int? child;

  List<BookListCommentVo>? children;

  factory BookListCommentVo.fromJson(Map<String, dynamic> json) =>
      _$BookListCommentVoFromJson(json);

  Map<String, dynamic> toJson() => _$BookListCommentVoToJson(this);
}
