import 'package:flutter/cupertino.dart';
import 'package:phone_number/phone_number.dart';

class IntlPhoneNumber {

  final String _countryCodeKey = 'country_code';
  final String _intlNumberKey = 'e164';
  final String _nationalNumberKey = 'national_number';

  final String initialValue;
  String internationalPhoneNumber;
  String localPhoneNumber;
  String countryCode;
  String dialCode;
  final PhoneNumber _plugin = PhoneNumber();
  Map<dynamic, dynamic> parsedPhoneNumber;

  IntlPhoneNumber({
        this.initialValue,
        this.internationalPhoneNumber,
        this.localPhoneNumber,
        this.countryCode,
        this.dialCode,
      });

  Future<bool> isValid({bool isInitialValueToTest = false}) async {
    String phoneNumber = isInitialValueToTest ? this.initialValue  : this.localPhoneNumber;
    assert(phoneNumber != null);
    this.parsedPhoneNumber = await _plugin
        .parse(phoneNumber, region: this.countryCode)
        .then((value) {
      decodeParsedNumber(value);
      return value;
    }).catchError((e) {
      debugPrint(e.toString());
      return null;
    });
    return this.parsedPhoneNumber != null;
  }

  decodeParsedNumber(Map<dynamic, dynamic>  decodedValues){
    this.dialCode = "+${decodedValues[_countryCodeKey]}";
    this.countryCode = decodedValues[_countryCodeKey];
    this.internationalPhoneNumber = decodedValues[_intlNumberKey];
    this.localPhoneNumber = decodedValues[_nationalNumberKey];
  }
}
