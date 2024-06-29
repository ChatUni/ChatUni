// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pricing _$PricingFromJson(Map<String, dynamic> json) => Pricing()
  ..id = (json['id'] as num).toInt()
  ..description = json['description'] as String
  ..time = (json['time'] as num).toInt()
  ..currency = json['currency'] as String
  ..fee = (json['fee'] as num).toInt()
  ..special = (json['special'] as num).toInt();

Map<String, dynamic> _$PricingToJson(Pricing instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'time': instance.time,
      'currency': instance.currency,
      'fee': instance.fee,
      'special': instance.special,
    };
