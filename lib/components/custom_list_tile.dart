import 'package:flutter/material.dart';

import '../constants.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.title,
    required this.onTap,
    required this.trailing,
    this.subtitle,
    this.icon,
    this.thirdLine,
  }) : super(key: key);

  final String title;
  final String trailing;
  final String? subtitle;
  final String? thirdLine;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {},
          child: Column(
            children: [
              ListTile(
                leading: icon != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            size: 40,
                            color: primaryColor,
                          ),
                        ],
                      )
                    : null,
                title: Text(
                  title,
                  style: TextStyle(
                    color: darkColor,
                  ),
                ),
                subtitle: Text(
                  "$subtitle${renderThirdLineIfExists()}",
                ),
                trailing: Text(trailing),
                onTap: onTap,
              ),
            ],
          ),
        ),
        Divider(height: 0, color: darkColor.withOpacity(.25)),
      ],
    );
  }

  String renderThirdLineIfExists() {
    return thirdLine != null ? "\n$thirdLine" : "";
  }
}
