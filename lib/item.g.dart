// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(json['name'] as String,
      amount: json['amount'] as int,
      size: json['size'] as String,
      imageUrl: json['imageUrl'] as String,
      addedDate: json['addedDate'] == null
          ? null
          : DateTime.parse(json['addedDate'] as String),
      manufacturerNote: json['manufacturerNote'] as String,
      attributes: (json['attributes'] as Map<String, dynamic>)
          ?.map((k, e) => MapEntry(k, e as String)));
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'size': instance.size,
      'manufacturerNote': instance.manufacturerNote,
      'attributes': instance.attributes,
      'addedDate': instance.addedDate?.toIso8601String(),
      'amount': instance.amount
    };
