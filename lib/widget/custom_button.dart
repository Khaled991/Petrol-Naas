import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.buttonColors,
    required this.textColors,
    required this.text,
    this.icon,
    required this.onPressed,
  }) : super(key: key);

  final Color buttonColors;
  final Color textColors;
  final IconData? icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      height: 47.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: buttonColors,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: textColors,
          textStyle: const TextStyle(
            fontSize: 18.0,
            letterSpacing: 1.5,
            fontFamily: 'Changa',
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  icon,
                  size: 30,
                ),
              ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
