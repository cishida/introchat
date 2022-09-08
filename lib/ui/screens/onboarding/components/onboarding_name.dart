// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:introchat/core/models/user/user.dart';
// import 'package:introchat/core/utils/constants/colors.dart';
// import 'package:introchat/ui/components/loading.dart';
// import 'package:provider/provider.dart';

// class OnboardingName extends StatefulWidget {
//   const OnboardingName({
//     Key key,
//   }) : super(key: key);

//   @override
//   _OnboardingNameState createState() => _OnboardingNameState();
// }

// class _OnboardingNameState extends State<OnboardingName> {
//   File _image;

//   Future getImage(String uid) async {
//     print(uid);
//     var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//     StorageReference ref =
//         FirebaseStorage.instance.ref().child('${uid}_profile_image');
//     StorageUploadTask uploadTask = ref.putFile(image);
//     var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

//     setState(() {
//       _image = image;
//     });

//     return downloadUrl;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userProfile = Provider.of<UserProfile>(context);

//     return (userProfile == null)
//         ? Loading()
//         : Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 vertical: 8.0,
//                 horizontal: 32.0,
//               ),
//               child: Column(
//                 children: <Widget>[
//                   // SizedBox(
//                   //   height: 25.0,
//                   // ),
//                   Text(
//                     "Thanks for joining Introchat! Let's\nget started by setting up your profile.",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: ConstantColors.ONBOARDING_TEXT,
//                       fontSize: 17.0,
//                       height: 1.5,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 30.0,
//                   ),
//                   TextFormField(
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16.0,
//                     ),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding: EdgeInsets.symmetric(
//                         vertical: 20.0,
//                         horizontal: 30.0,
//                       ),
//                       hintText: 'Full Name',
//                       hintStyle: TextStyle(
//                         color: ConstantColors.MESSAGE_PLACEHOLDER,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(30.0),
//                         ),
//                       ),
//                     ),
//                     initialValue: userProfile.displayName,
//                     onChanged: (text) {
//                       userProfile.displayName = text;
//                     },
//                   ),
//                   SizedBox(
//                     height: 10.0,
//                   ),
//                   TextFormField(
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16.0,
//                     ),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding: EdgeInsets.symmetric(
//                         vertical: 20.0,
//                         horizontal: 30.0,
//                       ),
//                       hintText: 'Zip Code',
//                       hintStyle: TextStyle(
//                         color: ConstantColors.MESSAGE_PLACEHOLDER,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(30.0),
//                         ),
//                       ),
//                     ),
//                     initialValue: userProfile.zip,
//                     onChanged: (text) {
//                       userProfile.zip = text;
//                     },
//                   ),
//                   SizedBox(
//                     height: 35.0,
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       userProfile.photoUrl = await getImage(userProfile.uid);
//                     },
//                     child: CircleAvatar(
//                       radius: 62.5,
//                       backgroundImage:
//                           _image == null ? null : FileImage(_image),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 19.0,
//                   ),
//                   Text(
//                     'Tap to add your photo',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 17.0,
//                       height: 1.0,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//   }
// }
