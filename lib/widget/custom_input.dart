import 'package:flutter/material.dart';

import '../constants.dart';

enum CustomInputTypes { white, password, yellow, transparent }

class CustomInput extends StatelessWidget {
  final String hintText;
  final CustomInputTypes type;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final bool showClearButton;

  const CustomInput({
    Key? key,
    required this.type,
    required this.hintText,
    this.showClearButton = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  Widget normalInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: TextField(
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
          suffixIcon: showClearButton
              ? GestureDetector(
                  onTap: () {
                    controller?.text = "";
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget transparentInput() {
    return TextField(
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 17,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        hintStyle: TextStyle(fontSize: 18.0, color: Colors.white70),
        contentPadding: EdgeInsets.all(0.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 1.2,
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 1.2,
            color: Colors.transparent,
          ),
        ),
        hintText: hintText,
        suffixIcon: showClearButton
            ? GestureDetector(
                onTap: () {
                  controller?.text = "";
                },
                child: Icon(
                  Icons.close,
                  color: Colors.white.withOpacity(0.9),
                ),
              )
            : null,
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: TextField(
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
          suffixIcon: showClearButton
              ? GestureDetector(
                  onTap: () {
                    controller?.text = "";
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget yellowInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
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
              suffixIcon: showClearButton
                  ? GestureDetector(
                      onTap: () {
                        controller?.text = "";
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CustomInputTypes.white:
        return normalInput();
      case CustomInputTypes.password:
        return passwordInput();
      case CustomInputTypes.yellow:
        return yellowInput();
      case CustomInputTypes.transparent:
        return transparentInput();
      default:
        return normalInput();
    }
  }
}
