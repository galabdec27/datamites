class CountryModel {
  final int country_id;
  final String country_name;
  final String currency_symbol;

  CountryModel({
    required this.country_id,
    required this.country_name,
    required this.currency_symbol,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      country_id: json['country_id'] as int,
      country_name: json['country_name']??"" as String,
      currency_symbol: json['currency_symbol']??"" as String,
    );
  }
}
