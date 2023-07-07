
import 'package:json_annotation/json_annotation.dart';

part 'catalog_vo.g.dart';

@JsonSerializable()
class CatalogVo{
   CatalogVo();

   late String id;

   late String name;

   late String createTime;

   factory CatalogVo.fromJson(Map<String,dynamic> json) => _$CatalogVoFromJson(json);
   Map<String, dynamic> toJson() => _$CatalogVoToJson(this);
}