import 'package:edrb/models/user_vo.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  Profile();

  UserVo? user;

  String? token;

  bool status = false;

  double? fontSize = 18;

  int? backgroundColor = 0xFFFFFFFF;
  int? fontColor = 0xFF000000;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
