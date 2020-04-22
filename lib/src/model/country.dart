class Country {
  final String numCode;
  final String alpha2Code;
  final String alpha3Code;
  final String enShortName;
  final String nationality;
  final String dialCode;

  Country({this.numCode, this.alpha2Code, this.alpha3Code, this.enShortName, this.nationality, this.dialCode});

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
Country _$CountryFromJson(Map<String, dynamic> json) {
  return Country(
    numCode: json['num_code'] as String,
    alpha2Code: json['alpha_2_code'] as String,
    alpha3Code: json['alpha_3_code'] as String,
    enShortName: json['en_short_name'] as String,
    nationality: json['nationality'] as String,
    dialCode: json['dial_code'] as String,
  );
}

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
  'num_code': instance.numCode,
  'alpha_2_code': instance.alpha2Code,
  'alpha_3_code': instance.alpha3Code,
  'en_short_name': instance.enShortName,
  'nationality': instance.nationality,
  'dial_code': instance.dialCode,
};