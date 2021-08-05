// import 'package:flutter/material.dart';
// import 'package:petrol_naas/constants.dart';

// class CustomAppBar extends StatelessWidget {
//   const CustomAppBar({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ClipPath(
//       // clipper: MyClipper(),
//       child: Container(
//         height: 200.0,
//         decoration: BoxDecoration(
//           color: Colors.green,
//           // primaryColor,
//         ),
//         child: Row(
//           children: [
//             Positioned(
//               top: 50.0,
//               left: 20.0,
//               child: IconButton(
//                 icon: Icon(Icons.menu),
//                 onPressed: () {},
//               ),
//             ),
//             Center(
//               child: Text(
//                 'إضافة فاتورة',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 30.0,
//                   fontFamily: 'Changa',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // class MyClipper extends CustomClipper<Path> {
// //   @override
// //   Path getClip(Size size) {
// //     Path path = new Path();
// //   }

// //   @override
// //   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
// //     // TODO: implement shouldReclip
// //     return true;
// //   }
// // }

// // class MyStatefulWidget extends StatefulWidget {
// //   const MyStatefulWidget({Key? key}) : super(key: key);

// //   @override
// //   State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
// // }

// // class _MyStatefulWidgetState extends State<MyStatefulWidget> {
// //   String dropdownValue = 'One';

// //   @override
// //   Widget build(BuildContext context) {
// //     return DropdownButton<String>(
// //       value: dropdownValue,
// //       icon: const Icon(Icons.arrow_drop_down),
// //       iconSize: 24,
// //       elevation: 16,
// //       style: const TextStyle(color: primaryColor),
// //       underline: Container(
// //         height: 2,
// //         color: primaryColor,
// //       ),
// //       onChanged: (String? newValue) {
// //         setState(() {
// //           dropdownValue = newValue!;
// //         });
// //       },
// //       items: <String>['One', 'Two', 'Free', 'Four']
// //           .map<DropdownMenuItem<String>>((String value) {
// //         return DropdownMenuItem<String>(
// //           value: value,
// //           child: Text(value),
// //         );
// //       }).toList(),
// //     );
// //   }
// // }
