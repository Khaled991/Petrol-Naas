import 'package:flutter/material.dart';

import '../constants.dart';

enum CustomInputTypes { white, password, yellow }

class CustomInput extends StatelessWidget {
  final String hintText;
  final CustomInputTypes type;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const CustomInput({
    Key? key,
    required this.type,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  TextField normalInput() {
    return TextField(
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 17,
        color: Colors.white,
      ),
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        hintStyle: TextStyle(fontSize: 18.0, color: Colors.white70),
        contentPadding: EdgeInsets.all(9.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 1.2,
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: hintText,
      ),
    );
  }

  TextField passwordInput() {
    return TextField(
      onChanged: onChanged,
      enableSuggestions: false,
      autocorrect: false,
      obscureText: true,
      style: TextStyle(
        fontSize: 17,
        color: Colors.white,
      ),
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        hintStyle: TextStyle(fontSize: 18.0, color: Colors.white70),
        contentPadding: EdgeInsets.all(9.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 1.2,
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: hintText,
      ),
    );
  }

  Widget yellowInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            hintText,
            style: TextStyle(
              fontSize: 18.0,
              color: darkColor,
            ),
          ),
        ),
        TextField(
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 17,
            color: darkColor,
          ),
          controller: controller,
          keyboardType: keyboardType,
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
            hintText: hintText,
          ),
        ),
      ],
    );
  }

  dynamic getInput(CustomInputTypes type) {
    if (type == CustomInputTypes.white) {
      return normalInput();
    } else if (type == CustomInputTypes.password) {
      return passwordInput();
    } else if (type == CustomInputTypes.yellow) {
      return yellowInput();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: getInput(type),
    );
  }
}
