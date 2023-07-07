// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentVo _$ContentVoFromJson(Map<String, dynamic> json) => ContentVo()
  ..bid = json['bid'] as String?
  ..cid = json['cid'] as String?
  ..name = json['name'] as String?
  ..catalog = json['catalog'] as String?
  ..txt = json['txt'] as String?
  ..shelf = json['shelf'] as bool;

Map<String, dynamic> _$ContentVoToJson(ContentVo instance) => <String, dynamic>{
      'bid': instance.bid,
      'cid': instance.cid,
      'name': instance.name,
      'catalog': instance.catalog,
      'txt': instance.txt,
      'shelf': instance.shelf,
    };
