import 'package:json_annotation/json_annotation.dart';

import 'book_vo.dart';
import 'catalog_vo.dart';

part 'book_detail_vo.g.dart';

@JsonSerializable()
class BookDetailVo {
  BookDetailVo();

  late BookVo? bookVo = BookVo();

  late List<CatalogVo>? catalogVos;

  late int? count;

  late bool? shelf = false;

  factory BookDetailVo.fromJson(Map<String, dynamic> json) =>
      _$BookDetailVoFromJson(json);

  Map<String, dynamic> toJson() => _$BookDetailVoToJson(this);
}
