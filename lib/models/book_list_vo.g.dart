// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_list_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookListVo _$BookListVoFromJson(Map<String, dynamic> json) => BookListVo()
  ..id = json['id'] as String?
  ..userVo = json['userVo'] == null
      ? null
      : UserVo.fromJson(json['userVo'] as Map<String, dynamic>)
  ..title = json['title'] as String?
  ..des = json['des'] as String?
  ..books = (json['books'] as List<dynamic>?)
      ?.map((e) => BookVo.fromJson(e as Map<String, dynamic>))
      .toList()
  ..status = json['status'] as String?
  ..time = json['time'] as String?;

Map<String, dynamic> _$BookListVoToJson(BookListVo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userVo': instance.userVo,
      'title': instance.title,
      'des': instance.des,
      'books': instance.books,
      'status': instance.status,
      'time': instance.time,
    };
