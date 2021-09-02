import 'package:flutter/material.dart';

import '../constants.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    Key? key,
    required this.type,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    required this.controller,
  }) : super(key: key);
  final String hintText, type;
  final TextInputType keyboardType;
  final TextEditingController controller;

  TextField normalInput() {
    return TextField(
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

  dynamic getInput(String type) {
    if (type == 'white') {
      return normalInput();
    } else if (type == 'password') {
      return passwordInput();
    } else if (type == 'yellow') return yellowInput();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: getInput(type),
    );
  }
}
