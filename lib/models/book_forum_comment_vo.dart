import 'package:edrb/models/user_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_forum_comment_vo.g.dart';

@JsonSerializable()
class BookForumCommentVo {
  BookForumCommentVo();

  String? prentId;

  String? id;

  String? bfId;

  UserVo? user;
  UserVo? replayUser;

  String? time;

  String? des;

  int? child;

  List<BookForumCommentVo>? children;

  factory BookForumCommentVo.fromJson(Map<String, dynamic> json) =>
      _$BookForumCommentVoFromJson(json);

  Map<String, dynamic> toJson() => _$BookForumCommentVoToJson(this);
}
