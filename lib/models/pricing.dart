import 'package:json_annotation/json_annotation.dart';

part 'pricing.g.dart';

@JsonSerializable()
class Pricing {
  int id = 0;
  String description = '';
  int time = 0;
  String currency = '';
  int fee = 0;
  double special = 0.0;

  Pricing();

  factory Pricing.fromJson(Map<String, dynamic> json) =>
      _$PricingFromJson(json);

  Map<String, dynamic> toJson() => _$PricingToJson(this);
}
