import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/screens/sign_in/sign_in.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import '../../constants.dart';

class DrawerOptionModel {
  late final String title;
  late final Widget body;
  late final IconData icon;
  DrawerOptionModel({
    required this.title,
    required this.body,
    required this.icon,
  });
}

class CustomDrawer extends StatelessWidget {
  final Function changeBodyIdx;
  final List<DrawerOptionModel> drawerOptions;

  const CustomDrawer({
    Key? key,
    required this.changeBodyIdx,
    required this.drawerOptions,
  }) : super(key: key);

  _buildDrawerOption(Icon icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<UserStore>();
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                ),
              ),
              alignment: Alignment.center,
              width: double.infinity - 10.0,
              height: 150.0,
              child: Observer(builder: (_) {
                return Text(
                  store.user.name ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                );
              }),
            ),

            ...List.generate(drawerOptions.length, (int i) {
              DrawerOptionModel drawerOptionProperties = drawerOptions[i];
              return _buildDrawerOption(
                Icon(
                  drawerOptionProperties.icon,
                  size: 27,
                  color: primaryColor,
                ),
                drawerOptionProperties.title,
                () {
                  changeBodyIdx(i);
                  Navigator.of(context).pop();
                },
              );
            } //_buildDrawerOption
                ).toList(),
            // _buildDrawerOption(
            //   Icon(
            //     Icons.add_box_outlined,
            //     size: 27,
            //     color: primaryColor,
            //   ),
            //   'إضافة فاتورة',
            //   () {
            //     changeBodyIdx(0);
            //     Navigator.of(context).pop();
            //   },
            // ), //_buildDrawerOption

            // _buildDrawerOption(
            //   Icon(
            //     Icons.receipt_outlined,
            //     size: 27,
            //     color: primaryColor,
            //   ),
            //   'الفواتير',
            //   () {
            //     changeBodyIdx(1);
            //     Navigator.of(context).pop();
            //   },
            // ), //_buildDrawerOption

            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: _buildDrawerOption(
                  Icon(
                    Icons.logout_outlined,
                    size: 27,
                    color: primaryColor,
                  ),
                  'تسجيل الخروج',
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SignIn(),
                    ),
                  ), //Navigator
                ), //_buildDrawerOption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
