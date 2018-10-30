// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      amount: json['amount'] as int,
      size: json['size'] as String,
      imageUrl: json['imageUrl'] as String,
      manufacturerNote: json['manufacturerNote'] as String,
      attributes: (json['attributes'] as Map<String, dynamic>)
          ?.map((k, e) => MapEntry(k, e as String)),
      changed: (json['changed'] as List)
          ?.map((e) => e == null ? null : DateTime.parse(e as String))
          ?.toList());
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'barcode': instance.barcode,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'size': instance.size,
      'manufacturerNote': instance.manufacturerNote,
      'attributes': instance.attributes,
      'amount': instance.amount,
      'changed': instance.changed?.map((e) => e?.toIso8601String())?.toList()
    };
