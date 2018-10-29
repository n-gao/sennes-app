// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Response _$ResponseFromJson(Map<String, dynamic> json) {
  return Response(json['error'], json['error_msg'], json['new_state'],
      json['updates'], json['info']);
}

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
      'error': instance.error,
      'error_msg': instance.errorMessage,
      'new_state': instance.newState,
      'updates': instance.updates,
      'info': instance.barcodeInfo
    };
