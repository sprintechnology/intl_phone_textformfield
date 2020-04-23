import 'package:flutter/cupertino.dart';
import 'package:phone_number/phone_number.dart';

class IntlPhoneNumber {
  final String intlPhoneNumber;
  final String localPhoneNumber;
  final String countryCode;
  final String dialCode;
  final PhoneNumber _plugin = PhoneNumber();
  Map<dynamic, dynamic> parsedPhoneNumber;

  IntlPhoneNumber(
      {this.intlPhoneNumber,
      this.localPhoneNumber,
      this.countryCode,
      this.dialCode});

  Future<bool> isValid() async {
    bool isValidPhone = false;
    if (this.localPhoneNumber != null && this.localPhoneNumber.length > 5) {
      this.parsedPhoneNumber = await _plugin
          .parse(this.localPhoneNumber, region: this.countryCode ?? 'US')
          .then((value) {
        return value;
      }).catchError((e) {
        debugPrint(e.toString());
        return null;
      });
      isValidPhone = this.parsedPhoneNumber != null;
    }
    return isValidPhone;
  }
}
