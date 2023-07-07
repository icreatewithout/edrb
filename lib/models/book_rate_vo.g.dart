// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_rate_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookRateVo _$BookRateVoFromJson(Map<String, dynamic> json) => BookRateVo()
  ..id = json['id'] as String?
  ..userVo = json['userVo'] == null
      ? null
      : UserVo.fromJson(json['userVo'] as Map<String, dynamic>)
  ..bid = json['bid'] as String?
  ..rate = json['rate'] as String?
  ..comments = json['comments'] as String?
  ..book = json['book'] == null
      ? null
      : BookVo.fromJson(json['book'] as Map<String, dynamic>)
  ..time = json['time'] as String?;

Map<String, dynamic> _$BookRateVoToJson(BookRateVo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userVo': instance.userVo,
      'bid': instance.bid,
      'rate': instance.rate,
      'comments': instance.comments,
      'book': instance.book,
      'time': instance.time,
    };
