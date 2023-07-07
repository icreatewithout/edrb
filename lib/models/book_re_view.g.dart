// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_re_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookReView _$BookReViewFromJson(Map<String, dynamic> json) => BookReView()
  ..id = json['id'] as String?
  ..title = json['title'] as String?
  ..des = json['des'] as String?
  ..type = json['type'] as String?
  ..time = json['time'] as String?
  ..user = json['user'] == null
      ? null
      : UserVo.fromJson(json['user'] as Map<String, dynamic>)
  ..books = (json['books'] as List<dynamic>?)
      ?.map((e) => BookVo.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$BookReViewToJson(BookReView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'des': instance.des,
      'type': instance.type,
      'time': instance.time,
      'user': instance.user,
      'books': instance.books,
    };
