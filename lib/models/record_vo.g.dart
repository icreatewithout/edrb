// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record _$RecordFromJson(Map<String, dynamic> json) => Record()
  ..bid = json['bid'] as String?
  ..cid = json['cid'] as String?
  ..name = json['name'] as String?
  ..cover = json['cover'] as String?;

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
      'bid': instance.bid,
      'cid': instance.cid,
      'name': instance.name,
      'cover': instance.cover,
    };
