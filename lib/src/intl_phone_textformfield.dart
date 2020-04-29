import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_textformfield/src/model/config.dart';
import 'package:intl_phone_textformfield/src/model/intl_phone_number.dart';
import 'model/country.dart';

class IntlPhoneTextFormField extends StatefulWidget {
  final String inputLabel;
  final IntlPhoneNumber phoneNumber;
  final String errorMessage;
  final bool autoValidate;
  final GlobalKey formKey;
  final List<String> countriesRestriction;
  final InputDecoration decoration;

  const IntlPhoneTextFormField(
      {Key key, @required this.inputLabel, @required this.phoneNumber, this.countriesRestriction, this.errorMessage, this.autoValidate, this.formKey, this.decoration})
      : super(key: key);

  @override
  _IntlPhoneTextFormFieldState createState() => _IntlPhoneTextFormFieldState();
}

class _IntlPhoneTextFormFieldState extends State<IntlPhoneTextFormField> {

  List<DropdownMenuItem<Country>> flags = List();
  TextEditingController phoneController = TextEditingController();
  String phoneControllerMessage;
  String errorMessage;
  List<Country> countries = [];
  Country selectedCountry = Country();
  IntlPhoneNumber currentIntlPhoneNumber = IntlPhoneNumber();

  loadCountries() async {
    String jsonCountryList = await DefaultAssetBundle.of(context)
        .loadString('packages/${PhoneDefaultConfig.packageName}/assets/countries.json');
    assert(jsonCountryList != null);
    json.decode(jsonCountryList).forEach((element) {
      Country country = Country.fromJson(element);
      if (widget.countriesRestriction != null) {
        if(widget.countriesRestriction.contains(country.alpha2Code)){
          countries.add(country);
        }
      } else {
        countries.add(country);
      }
    });
    setState(() {
      countries.sort((a, b) => a.dialCode.compareTo(b.dialCode));
      selectedCountry = countries[0];
    });
    if (widget.phoneNumber?.initialValue != null) {
      validateInitialValue();
    }
  }

  Future validatePhoneNumber({String phoneNumber}) async {
    currentIntlPhoneNumber = IntlPhoneNumber(
      countryCode: selectedCountry.alpha2Code,
      dialCode: selectedCountry.dialCode,
      localPhoneNumber: phoneNumber != null ? phoneNumber : phoneController
          ?.text,
    );
    bool isValid = await currentIntlPhoneNumber.isValid();
    setState(() {
      phoneControllerMessage = isValid ? null : errorMessage;
    });
  }

  @override
  void initState() {
    loadCountries();
    errorMessage =
        widget.errorMessage ?? PhoneDefaultConfig.defaultErrorMessage;
    super.initState();
  }

  validateInitialValue() async{
    bool isValid = await widget.phoneNumber.isValid(isInitialValueToTest: true);
    if(isValid){
      selectedCountry = countries.firstWhere((element) => element.dialCode == widget.phoneNumber.dialCode) ?? Country();
      phoneController.text = widget.phoneNumber.localPhoneNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        DropdownButtonHideUnderline(
          child: DropdownButton<Country>(
            value: selectedCountry,
            onChanged: (Country newCountry) {
              setState(() {
                selectedCountry = newCountry;
              });
              validatePhoneNumber();
            },
            items: countries.map<DropdownMenuItem<Country>>((Country value) {
              return DropdownMenuItem<Country>(
                value: value,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset(
                        'assets/flags/${value.alpha2Code.toLowerCase()}.png',
                        width: 32.0,
                        package: PhoneDefaultConfig.packageName,
                      ),
                      SizedBox(width: 4),
                      Text(value.dialCode)
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Flexible(
          child: TextFormField(
            key: widget.formKey,
            keyboardType: TextInputType.phone,
            maxLines: 1,
            controller: phoneController,
            autovalidate: widget.autoValidate ?? false,
            decoration: widget.decoration ?? InputDecoration(
              isDense: false,
              contentPadding: EdgeInsets.only(top: 5),
              labelText: widget.inputLabel,
            ),
            validator: (String value) {
              if (value.isEmpty || value.length < 5) {
                phoneControllerMessage = null;
              } else {
                validatePhoneNumber(phoneNumber: value);
              }
              return phoneControllerMessage;
            },
          ),
        )
      ]),
    );
  }
}