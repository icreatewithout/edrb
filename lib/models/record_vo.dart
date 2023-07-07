

import 'package:json_annotation/json_annotation.dart';

part 'record_vo.g.dart';

@JsonSerializable()
class Record{
  Record();

  String? bid;
  String? cid;
  String? name;
  String? cover;

  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);

  Map<String, dynamic> toJson() => _$RecordToJson(this);
}