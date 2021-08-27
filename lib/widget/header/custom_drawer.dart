import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petrol_naas/pages/sign_in/sign_in.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:provider/src/provider.dart';
import '../../constants.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
    required this.changeBodyIdx,
  }) : super(key: key);

  final Function changeBodyIdx;

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
                    //TODO: enable overflow
                    // overflow: TextOverflow.ellipsis,
                  ),
                );
              }),
            ),

            _buildDrawerOption(
              Icon(
                Icons.add_box_outlined,
                size: 27,
                color: primaryColor,
              ),
              'إضافة فاتورة',
              () {
                changeBodyIdx(0);
                Navigator.of(context).pop();
              },
            ), //_buildDrawerOption
            _buildDrawerOption(
              Icon(
                Icons.receipt_outlined,
                size: 27,
                color: primaryColor,
              ),
              'الفواتير',
              () {
                changeBodyIdx(1);
                Navigator.of(context).pop();
              },
            ), //_buildDrawerOption

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
