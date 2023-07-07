import 'package:edrb/models/book_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'author_book.g.dart';

@JsonSerializable()
class AuthorBook {
  AuthorBook();

  int? count;
  List<BookVo>? list;

  factory AuthorBook.fromJson(Map<String, dynamic> json) =>
      _$AuthorBookFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorBookToJson(this);
}
