
import 'package:json_annotation/json_annotation.dart';

part 'book_list_count.g.dart';

@JsonSerializable()
class BookListCount{
  BookListCount();

  bool? thumb;

  int? count;
  int? comment;

  factory BookListCount.fromJson(Map<String, dynamic> json) =>
      _$BookListCountFromJson(json);

  Map<String, dynamic> toJson() => _$BookListCountToJson(this);
}