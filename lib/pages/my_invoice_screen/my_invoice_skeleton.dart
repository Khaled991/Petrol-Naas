import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../../constants.dart';

class MyInvoiceSkeleton extends StatelessWidget {
  final Widget? child;

  const MyInvoiceSkeleton({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SkeletonLoader(
        builder: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Row(
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                color: Colors.white,
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 9,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 120,
                      height: 9,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Container(
                width: 90,
                height: 9,
                color: Colors.white,
              ),
            ],
          ),
        ),
        items: 10,
        period: Duration(seconds: 2),
        highlightColor: primaryColor,
        direction: SkeletonDirection.rtl,
      ),
    );
  }
}
