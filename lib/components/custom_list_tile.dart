import 'package:flutter/material.dart';

import '../constants.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.title,
    required this.onTap,
    required this.date,
    required this.subtitle,
    required this.icon,
    this.thirdLine,
  }) : super(key: key);

  final String title;
  final String date;
  final String subtitle;
  final String? thirdLine;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {},
          child: Column(
            children: [
              ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 40,
                      color: primaryColor,
                    ),
                  ],
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    color: darkColor,
                  ),
                ),
                subtitle: Text(
                  "$subtitle${renderThirdLineIfExists()}",
                ),
                trailing: Text(date),
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
