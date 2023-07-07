// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookVo _$BookVoFromJson(Map<String, dynamic> json) => BookVo()
  ..id = json['id'] as String
  ..name = json['name'] as String?
  ..category = json['category'] as String?
  ..author = json['author'] as String?
  ..des = json['des'] as String?
  ..type = json['type'] as String?
  ..cover = json['cover'] as String?
  ..readCount = json['readCount'] as int?
  ..rate = json['rate'] as String?;

Map<String, dynamic> _$BookVoToJson(BookVo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'author': instance.author,
      'des': instance.des,
      'type': instance.type,
      'cover': instance.cover,
      'readCount': instance.readCount,
      'rate': instance.rate,
    };
