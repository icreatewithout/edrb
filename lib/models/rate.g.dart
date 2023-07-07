// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rate _$RateFromJson(Map<String, dynamic> json) => Rate()
  ..count = json['count'] as int?
  ..r1 = (json['r1'] as num?)?.toDouble()
  ..r2 = (json['r2'] as num?)?.toDouble()
  ..r3 = (json['r3'] as num?)?.toDouble();

Map<String, dynamic> _$RateToJson(Rate instance) => <String, dynamic>{
      'count': instance.count,
      'r1': instance.r1,
      'r2': instance.r2,
      'r3': instance.r3,
    };
