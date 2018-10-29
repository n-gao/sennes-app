import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
// Response already exists in the http library
class Response {
  int error;
  @JsonKey(name: 'error_msg')
  String errorMessage;
  @JsonKey(name: 'new_state')
  int newState;
  List<String> updates;
  @JsonKey(name: 'info')
  List<Map<String, dynamic>> barcodeInfo;

  Response(error, errorMessage, newState, updates, barcodeInfo);

  factory Response.fromJson(Map<String, dynamic> json) => _$ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseToJson(this);
}
