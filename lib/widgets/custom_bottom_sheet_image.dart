//  import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';

// Future<dynamic> buildGetImageBottomSheet(BuildContext context) {
//     return showModalBottomSheet(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(16.0.r),
//           topRight: Radius.circular(16.0.r),
//         ),
//       ),
//       context: context,
//       builder: (context) => SizedBox(
//           height: 130.h,
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: InkWell(
//                     onTap: () {
//                       pickImage(ImageSource.camera);
//                       Navigator.pop(context);
//                     },
//                     child: Row(
//                       children: [
//                         const Icon(Icons.camera),
//                         SizedBox(
//                           width: 15.w,
//                         ),
//                         Text(
//                           "Camera",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15.sp,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const Divider(
//                   thickness: 1,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: InkWell(
//                     onTap: () {
//                       pickImage(ImageSource.gallery);
//                       Navigator.pop(context);
//                     },
//                     child: Row(
//                       children: [
//                         const Icon(Icons.photo),
//                         SizedBox(
//                           width: 15.w,
//                         ),
//                         Text(
//                           "Gallery",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15.sp,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           )),
//     );
//   }