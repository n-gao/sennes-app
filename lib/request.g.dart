// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Request _$RequestFromJson(Map<String, dynamic> json) {
  return Request(json['fridge_id'], json['method'], json['state'],
      json['barcodes'], json['update']);
}

Map<String, dynamic> _$RequestToJson(Request instance) => <String, dynamic>{
      'fridge_id': instance.fridgeId,
      'method': instance.method,
      'state': instance.state,
      'barcodes': instance.barcodes,
      'update': instance.update
    };
