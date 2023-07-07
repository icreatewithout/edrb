import 'package:edrb/models/book_vo.dart';
import 'package:edrb/models/user_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_rate_vo.g.dart';

@JsonSerializable()
class BookRateVo {
  BookRateVo();

  String? id;

  UserVo? userVo;

  String? bid;

  String? rate;

  String? comments;

  BookVo? book;

  String? time;

  factory BookRateVo.fromJson(Map<String, dynamic> json) =>
      _$BookRateVoFromJson(json);

  Map<String, dynamic> toJson() => _$BookRateVoToJson(this);
}
