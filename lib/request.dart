import 'package:json_annotation/json_annotation.dart';

part 'request.g.dart';

@JsonSerializable()
class Request {
  @JsonKey(name: 'fridge_id')
  int fridgeId;
  String method;
  int state;
  List<String> barcodes;
  String update;

  Request(fridgeId, method, state, barcodes, update);

  factory Request.getUpdates(fridgeId, state){
    return Request(fridgeId, "get_updates", state, null, null);
  }

  factory Request.addUpdate(fridgeId, update){
    return Request(fridgeId, "add_update", null, null, update);
  }

  factory Request.barcodeInfo(barcodes){
    return Request(null, "barcode_info", null, barcodes, null);
  }

  factory Request.fromJson(Map<String, dynamic> json) => _$RequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestToJson(this);
}
