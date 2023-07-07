// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_detail_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookDetailVo _$BookDetailVoFromJson(Map<String, dynamic> json) => BookDetailVo()
  ..bookVo = json['bookVo'] == null
      ? null
      : BookVo.fromJson(json['bookVo'] as Map<String, dynamic>)
  ..catalogVos = (json['catalogVos'] as List<dynamic>?)
      ?.map((e) => CatalogVo.fromJson(e as Map<String, dynamic>))
      .toList()
  ..count = json['count'] as int?
  ..shelf = json['shelf'] as bool?;

Map<String, dynamic> _$BookDetailVoToJson(BookDetailVo instance) =>
    <String, dynamic>{
      'bookVo': instance.bookVo,
      'catalogVos': instance.catalogVos,
      'count': instance.count,
      'shelf': instance.shelf,
    };
