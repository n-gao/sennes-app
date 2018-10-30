import 'package:json_annotation/json_annotation.dart';

part 'item_update.g.dart';

@JsonSerializable()
class ItemUpdate {
  int method;
  @JsonKey(name: 'method_name')
  String methodName;
  String barcode;
  int timestamp;

  ItemUpdate({this.method, this.methodName, this.barcode, this.timestamp});

  factory ItemUpdate.fromJson(Map<String, dynamic> json) => _$ItemUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$ItemUpdateToJson(this);
}
