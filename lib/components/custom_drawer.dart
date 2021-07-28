import 'package:flutter/material.dart';
import 'package:petrol_naas/home/sign_in.dart';

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
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  // bottomRight: Radius.circular(20),
                ),
              ),
              alignment: Alignment.center,
              width: double.infinity - 10.0,
              height: 150.0,
              child: Text(
                'خالد وليد محمدخالد وليد محمد',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            _buildDrawerOption(
              Icon(
                Icons.add,
                size: 27,
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
                    Icons.exit_to_app_outlined,
                    size: 27,
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
