import 'package:flutter/material.dart';

import '../constants.dart';

class CustomDropdown<T> extends StatelessWidget {
  final dynamic textProperty;
  late final List<T> elements;
  late String label;
  final T? selectedValue;

  final void Function(T? value) onChanged;
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
          dropDownElementsList.add(DropdownMenuItem(
            child: Text(displayedText),
            value: element,
          ));
        } else if (textProperty is List<String>) {
          final List<Widget> listOfTextsWidget = List.generate(
            textProperty.length,
            (index) => index % 2 == 0
                ? Expanded(
                    child: Text("${element.toJson()[textProperty[index]]}"),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(
                      "${element.toJson()[textProperty[index]]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
          );

          // textProperty
          //     .map<Text>((String property) => Text(element.toJson()[property]));

          dropDownElementsList.add(DropdownMenuItem(
            child: Row(
              children: listOfTextsWidget,
            ),
            value: element,
          ));
        } else {
          displayedText = element.toJson()[textProperty].toString();
          dropDownElementsList.add(DropdownMenuItem(
            child: Text(displayedText),
            value: element,
          ));
        }
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
                    color: Colors.black,
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
