// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_forum_comment_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookForumCommentVo _$BookForumCommentVoFromJson(Map<String, dynamic> json) =>
    BookForumCommentVo()
      ..prentId = json['prentId'] as String?
      ..id = json['id'] as String?
      ..bfId = json['bfId'] as String?
      ..user = json['user'] == null
          ? null
          : UserVo.fromJson(json['user'] as Map<String, dynamic>)
      ..replayUser = json['replayUser'] == null
          ? null
          : UserVo.fromJson(json['replayUser'] as Map<String, dynamic>)
      ..time = json['time'] as String?
      ..des = json['des'] as String?
      ..child = json['child'] as int?
      ..children = (json['children'] as List<dynamic>?)
          ?.map((e) => BookForumCommentVo.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$BookForumCommentVoToJson(BookForumCommentVo instance) =>
    <String, dynamic>{
      'prentId': instance.prentId,
      'id': instance.id,
      'bfId': instance.bfId,
      'user': instance.user,
      'replayUser': instance.replayUser,
      'time': instance.time,
      'des': instance.des,
      'child': instance.child,
      'children': instance.children,
    };
