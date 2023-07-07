import 'package:json_annotation/json_annotation.dart';

part 'book_vo.g.dart';

@JsonSerializable()
class BookVo {
  BookVo();

  late String id = '';

  late String? name = '';

  late String? category;

  late String? author = '';

  late String? des = '';

  late String? type;

  late String? cover;

  late int? readCount;

  late String? rate;

  factory BookVo.fromJson(Map<String, dynamic> json) => _$BookVoFromJson(json);

  Map<String, dynamic> toJson() => _$BookVoToJson(this);
}
