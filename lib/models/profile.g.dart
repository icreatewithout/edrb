// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile()
  ..user = json['user'] == null
      ? null
      : UserVo.fromJson(json['user'] as Map<String, dynamic>)
  ..token = json['token'] as String?
  ..status = json['status'] as bool
  ..fontSize = (json['fontSize'] as num?)?.toDouble()
  ..backgroundColor = json['backgroundColor'] as int?
  ..fontColor = json['fontColor'] as int?;

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
      'status': instance.status,
      'fontSize': instance.fontSize,
      'backgroundColor': instance.backgroundColor,
      'fontColor': instance.fontColor,
    };
