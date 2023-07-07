
import 'package:json_annotation/json_annotation.dart';

part 'user_vo.g.dart';

@JsonSerializable()
class UserVo {
  UserVo();

  String? id;

  String? nickName;
  String? avatarUrl;

  factory UserVo.fromJson(Map<String,dynamic> json) => _$UserVoFromJson(json);
  Map<String, dynamic> toJson() => _$UserVoToJson(this);
}
