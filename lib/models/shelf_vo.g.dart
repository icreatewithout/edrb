// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shelf_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShelfVo _$ShelfVoFromJson(Map<String, dynamic> json) => ShelfVo()
  ..id = json['id'] as String?
  ..uid = json['uid'] as String?
  ..bid = json['bid'] as String?
  ..cid = json['cid'] as String?
  ..bookVo = json['bookVo'] == null
      ? null
      : BookVo.fromJson(json['bookVo'] as Map<String, dynamic>)
  ..select = json['select'] as bool?;

Map<String, dynamic> _$ShelfVoToJson(ShelfVo instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'bid': instance.bid,
      'cid': instance.cid,
      'bookVo': instance.bookVo,
      'select': instance.select,
    };
