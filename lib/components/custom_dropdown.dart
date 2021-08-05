import 'package:flutter/material.dart';

import '../constants.dart';

/// This is the stateful widget that the main application instantiates.
class CustomDropdown extends StatefulWidget {
  final List<String> itemsList;
  final String text;
  final void Function(int payTypeIdx) onChange;
  const CustomDropdown({
    Key? key,
    required this.itemsList,
    required this.text,
    required this.onChange,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _CustomDropdownState extends State<CustomDropdown> {
  late String dropdownHint;

  @override
  void initState() {
    dropdownHint = widget.text;
    super.initState();
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
              widget.text,
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
                child: DropdownButtonFormField<String>(
                  // value: dropdownValue,
                  decoration: InputDecoration.collapsed(hintText: ''),
                  hint: Text(
                    dropdownHint,
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
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownHint = newValue!;
                    });
                    widget.onChange(widget.itemsList.indexOf(newValue!));
                  },

                  items: widget.itemsList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:dropdown_below/dropdown_below.dart';
// import 'package:flutter/material.dart';
// import 'package:petrol_naas/constants.dart';
// import 'package:petrol_naas/models/invoice.dart';

// class CustomDropdown extends StatefulWidget {
//   @override
//   const CustomDropdown({
//     Key? key,
//     required this.text,
//     required this.itemsList,
//   }) : super(key: key);
//   final String text;
//   final List<String> itemsList;

//   _CustomDropdownState createState() => _CustomDropdownState();
// }

// class _CustomDropdownState extends State<CustomDropdown> {
//   late String _text;
//   late final List<Map<String, Object>> _itemsList;
//   List<DropdownMenuItem<Object?>> _dropdownTestItems = [];

//   var _selectedTest;

//   void prepareItemsList() {
//     _itemsList = List.generate(
//       widget.itemsList.length,
//       (int i) => ({"no": i + 1, "keyword": widget.itemsList[i]}),
//     );
//   }

//   @override
//   void initState() {
//     prepareItemsList();
//     _dropdownTestItems = buildDropdownTestItems(_itemsList);
//     _text = widget.text;
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   List<DropdownMenuItem<Object?>> buildDropdownTestItems(List _testList) {
//     List<DropdownMenuItem<Object?>> items = [];
//     for (var i in _testList) {
//       items.add(
//         DropdownMenuItem(
//           value: i,
//           child: Text(i['keyword']),
//         ),
//       );
//     }
//     return items;
//   }

//   onChangeDropdownTests(selectedTest) {
//     setState(() {
//       _selectedTest = selectedTest;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: Text(
//               _text,
//               style: TextStyle(
//                 fontSize: 18.0,
//                 color: darkColor,
//               ),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10.0),
//               border: Border.all(
//                 color: primaryColor,
//                 style: BorderStyle.solid,
//                 width: 1.2,
//               ),
//             ),
//             child: DropdownBelow(
//               itemWidth: MediaQuery.of(context).size.width,
//               itemTextstyle: TextStyle(
//                 fontSize: 15,
//                 fontFamily: 'Changa',
//               ),
//               boxTextstyle: TextStyle(
//                 fontSize: 15,
//                 fontFamily: 'Changa',
//                 color: Color(0x993d3d3d),
//               ),
//               boxPadding: const EdgeInsets.all(10.0),
//               boxWidth: double.infinity,
//               boxHeight: 45,
//               hint: Text(_text),
//               value: _selectedTest,
//               items: _dropdownTestItems,
//               onChanged: onChangeDropdownTests,
//               icon: Icon(
//                 Icons.expand_more,
//                 color: primaryColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
