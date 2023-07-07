// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_list_comment_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookListCommentVo _$BookListCommentVoFromJson(Map<String, dynamic> json) =>
    BookListCommentVo()
      ..prentId = json['prentId'] as String?
      ..id = json['id'] as String?
      ..blId = json['blId'] as String?
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
          ?.map((e) => BookListCommentVo.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$BookListCommentVoToJson(BookListCommentVo instance) =>
    <String, dynamic>{
      'prentId': instance.prentId,
      'id': instance.id,
      'blId': instance.blId,
      'user': instance.user,
      'replayUser': instance.replayUser,
      'time': instance.time,
      'des': instance.des,
      'child': instance.child,
      'children': instance.children,
    };
