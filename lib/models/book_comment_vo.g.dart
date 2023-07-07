// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_comment_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookCommentVo _$BookCommentVoFromJson(Map<String, dynamic> json) =>
    BookCommentVo()
      ..id = json['id'] as String?
      ..type = json['type'] as String?
      ..des = json['des'] as String?
      ..user = json['user'] == null
          ? null
          : UserVo.fromJson(json['user'] as Map<String, dynamic>)
      ..replayUser = json['replayUser'] == null
          ? null
          : UserVo.fromJson(json['replayUser'] as Map<String, dynamic>)
      ..forum = json['forum'] == null
          ? null
          : BookForum.fromJson(json['forum'] as Map<String, dynamic>)
      ..list = json['list'] == null
          ? null
          : BookListVo.fromJson(json['list'] as Map<String, dynamic>)
      ..time = json['time'] as String?;

Map<String, dynamic> _$BookCommentVoToJson(BookCommentVo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'des': instance.des,
      'user': instance.user,
      'replayUser': instance.replayUser,
      'forum': instance.forum,
      'list': instance.list,
      'time': instance.time,
    };
