// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorBook _$AuthorBookFromJson(Map<String, dynamic> json) => AuthorBook()
  ..count = json['count'] as int?
  ..list = (json['list'] as List<dynamic>?)
      ?.map((e) => BookVo.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$AuthorBookToJson(AuthorBook instance) =>
    <String, dynamic>{
      'count': instance.count,
      'list': instance.list,
    };
