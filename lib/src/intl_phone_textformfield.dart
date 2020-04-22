import 'dart:convert';

import 'package:flutter/material.dart';

import 'model/country.dart';

class IntlPhoneTextFormField extends StatefulWidget {

  final TextEditingController phoneNumberController;

  const IntlPhoneTextFormField({Key key, this.phoneNumberController}) : super(key: key);

  @override
  _IntlPhoneTextFormFieldState createState() => _IntlPhoneTextFormFieldState();
}

class _IntlPhoneTextFormFieldState extends State<IntlPhoneTextFormField> {

  final String packageName = 'intl_phone_textformfield';
  List<DropdownMenuItem<Country>> flags = List();
  List<Country> countries = [];
  Country selectedCountry;

  loadCountries() async {
    String list = await DefaultAssetBundle.of(context).loadString('packages/$packageName/assets/countries.json');
    json.decode(list).forEach((element) {
      setState(() {
        countries.add(Country.fromJson(element));
      });
    });
  }


  @override
  void initState() {
    loadCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<Country>(
              value: selectedCountry,
              items: countries.map<DropdownMenuItem<Country>>((Country value) {
                return DropdownMenuItem<Country>(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset(
                          'assets/flags/${value.alpha2Code.toLowerCase()}.png',
                          width: 32.0,
                          package: packageName,
                        ),
                        SizedBox(width: 4),
                        Text(value.dialCode)
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (Country newCountry) {
                setState(() {
                  selectedCountry = newCountry;
                });
              },
            ),
          ),
          Flexible(
            child: TextFormField(
              controller: widget.phoneNumberController,
              decoration: InputDecoration(

              ),
            ),
          )
        ]
      ),
    );
  }
}
