import 'package:flutter/material.dart';

import '../constants.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String? textProperty;
  late final List<T> elements;
  late String label;
  T? selectedValue;

  void Function(T? value) onChanged;
  CustomDropdown({
    Key? key,
    this.textProperty,
    required this.elements,
    required this.label,
    required this.onChanged,
    required this.selectedValue,
  }) : super(key: key);

  List<DropdownMenuItem<T>> _getDropDownItems() {
    List<DropdownMenuItem<T>> dropDownElementsList = [];

    if (elements.isEmpty) {
      dropDownElementsList.add(DropdownMenuItem(
        child: Text(label),
      ));
    } else {
      for (dynamic element in elements) {
        late final String displayedText;

        if (textProperty == null) {
          displayedText = element.toString();
        } else {
          displayedText = element.toJson()[textProperty].toString();
        }

        dropDownElementsList.add(DropdownMenuItem(
          child: Text(displayedText),
          value: element,
        ));
      }
    }

    return dropDownElementsList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18.0,
                color: darkColor,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: primaryColor,
                style: BorderStyle.solid,
                width: 1.2,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
                child: DropdownButtonFormField<T>(
                  decoration: InputDecoration.collapsed(hintText: ''),
                  hint: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  icon: const Icon(
                    Icons.expand_more,
                    color: primaryColor,
                  ),
                  iconSize: 24,
                  elevation: 16,
                  isExpanded: true,
                  isDense: true,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'Changa',
                    color: Color(0x993d3d3d),
                  ),
                  items: _getDropDownItems(),
                  onChanged: onChanged,
                  value: selectedValue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
