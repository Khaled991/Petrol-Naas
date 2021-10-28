import 'package:flutter/material.dart';

import '../../constants.dart';

class ExpandCustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final void Function(String)? onChanged;

  const ExpandCustomTextField({
    Key? key,
    this.controller,
    required this.label,
    this.onChanged,
  }) : super(key: key);

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
          TextFormField(
            onChanged: onChanged,
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: 18.0, color: Color(0x993d3d3d)),
              contentPadding: EdgeInsets.all(9.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(width: 1.2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  width: 1.2,
                  color: primaryColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: primaryColor, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintText: 'ملاحظات',
            ),
          ),
        ],
      ),
    );
  }
}
