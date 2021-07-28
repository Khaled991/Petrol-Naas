import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import 'custom_button.dart';
import 'custom_dropdown.dart';

class InvoiceHeader extends StatefulWidget {
  const InvoiceHeader({
    Key? key,
  }) : super(key: key);

  @override
  State<InvoiceHeader> createState() => _InvoiceHeaderState();
}

class _InvoiceHeaderState extends State<InvoiceHeader> {
  DateTime _firstDate = DateTime.now();
  DateTime _lastDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'جميع الفواتير',
            style: TextStyle(
              color: darkColor,
              fontSize: 18.0,
            ),
          ),
          TextButton(
            child: Icon(
              Icons.sort,
              size: 30.0,
              color: primaryColor,
            ),
            onPressed: () => showFilterModal(context),
          ),
        ],
      ),
    );
  }

  Future<void> showFilterModal(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return BottomSheet(
            onClosing: () {},
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (BuildContext ctx, setState) {
                return Column(
                  children: [
                    Text(
                      'ترتيب الفواتير',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: darkColor,
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      width: double.infinity,
                      child: CustomDropdown(
                        itemsList: <String>[
                          'محمد',
                          'محمد الخرمان',
                          'ابو حيوان الفرطان',
                          'ابو سمعيل'
                        ],
                        text: 'اسم العميل',
                        onChange: (int) {},
                      ),
                    ),
                    Divider(),
                    Text(
                      'اختيار تاريخ',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: darkColor,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              ).then(
                                (date) {
                                  setState(() {
                                    _firstDate = date!;
                                  });
                                },
                              );
                            },
                            buttonColors: primaryColor,
                            text: 'من',
                            icon: Icons.date_range_outlined,
                            textColors: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Text(
                            _firstDate == null
                                ? _firstDate.toString()
                                : DateFormat("dd-MM-yyyy").format(_firstDate),
                            style: TextStyle(
                              color: darkColor,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              ).then(
                                (date) {
                                  setState(() {
                                    _lastDate = date!;
                                  });
                                },
                              );
                            },
                            buttonColors: primaryColor,
                            text: 'إلي',
                            icon: Icons.date_range_outlined,
                            textColors: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Text(
                            _lastDate == null
                                ? _lastDate.toString()
                                : DateFormat("dd-MM-yyyy").format(_lastDate),
                            style: TextStyle(
                              color: darkColor,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            buttonColors: greenColor,
                            onPressed: () {
                              if (_firstDate.compareTo(_lastDate) < 0) {
                                Text('good');
                                Navigator.pop(context);
                              } else {
                                Text('التاريخ غير صحيح');
                                // Fluttertoast.showToast(
                                //   msg: "التاريخ غير صحيح",
                                //   toastLength: Toast.LENGTH_SHORT,
                                //   gravity: ToastGravity.CENTER,
                                //   timeInSecForIosWeb: 200,
                                // );
                              }
                            },
                            text: 'حفظ',
                            textColors: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: CustomButton(
                            buttonColors: redColor,
                            onPressed: () => Navigator.pop(context),
                            text: 'إلغاء',
                            textColors: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              });
            });
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime>('_dateTime', _firstDate));
    properties.add(DiagnosticsProperty<DateTime>('_dateTime', _firstDate));
  }
}
