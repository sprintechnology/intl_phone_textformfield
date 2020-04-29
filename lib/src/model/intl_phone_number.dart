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
  bool isValid = false;
  final PhoneNumber _plugin = PhoneNumber();
  Map<dynamic, dynamic> parsedPhoneNumber;

  IntlPhoneNumber({
        this.initialValue,
        this.internationalPhoneNumber,
        this.localPhoneNumber,
        this.countryCode,
        this.dialCode,
      });

  Future<bool> testPhoneNumberValidity({bool isInitialValueToTest = false}) async {
    String phoneNumber = isInitialValueToTest ? this.initialValue  : this.localPhoneNumber;
    assert(phoneNumber != null);
    _cleanValues();
    this.parsedPhoneNumber = await _plugin
        .parse(phoneNumber, region: this.countryCode)
        .then((value) {
      _decodeParsedNumber(value);
      return value;
    }).catchError((e) {
      debugPrint(e.toString());
      return null;
    });
    this.isValid = this.parsedPhoneNumber != null;
    return this.isValid;
  }

  _cleanValues(){
    this.dialCode = null;
    this.countryCode = null;
    this.internationalPhoneNumber = null;
    this.localPhoneNumber = null;
  }

  _decodeParsedNumber(Map<dynamic, dynamic>  decodedValues){
    this.dialCode = "+${decodedValues[_countryCodeKey]}";
    this.countryCode = decodedValues[_countryCodeKey];
    this.internationalPhoneNumber = decodedValues[_intlNumberKey];
    this.localPhoneNumber = decodedValues[_nationalNumberKey];
  }
}
