import 'package:edrb/models/book_forum.dart';
import 'package:edrb/models/book_list_vo.dart';
import 'package:edrb/models/user_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_comment_vo.g.dart';

@JsonSerializable()
class BookCommentVo {
  BookCommentVo();

  String? id;

  String? type; // 1 list 2 forum
  String? des;

  UserVo? user;
  UserVo? replayUser;

  BookForum? forum;
  BookListVo? list;
  String? time;


  factory BookCommentVo.fromJson(Map<String, dynamic> json) =>
      _$BookCommentVoFromJson(json);

  Map<String, dynamic> toJson() => _$BookCommentVoToJson(this);
}
