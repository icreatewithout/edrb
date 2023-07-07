// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category()
  ..id = json['id'] as String
  ..name = json['name'] as String
  ..val = json['val'] as String
  ..otherName = json['otherName'] as String?;

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'val': instance.val,
      'otherName': instance.otherName,
    };
