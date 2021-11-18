import 'package:flutter/material.dart';

class WithLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const WithLoading({
    Key? key,
    required this.child,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black38,
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffe8bd34)),
              ),
            ),
          )
      ],
    );
  }
}
