import 'package:json_annotation/json_annotation.dart';

part 'content_vo.g.dart';

@JsonSerializable()
class ContentVo {
  ContentVo();

  String? bid;

  String? cid;

  String? name;
  String? catalog;
  String? txt;

  bool shelf = false;

  factory ContentVo.fromJson(Map<String,dynamic> json) => _$ContentVoFromJson(json);
  Map<String, dynamic> toJson() => _$ContentVoToJson(this);
}
