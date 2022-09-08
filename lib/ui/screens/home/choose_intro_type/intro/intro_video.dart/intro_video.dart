// import 'package:flushbar/flushbar.dart';
// import 'package:flutter/material.dart';
// import 'package:introchat/core/models/user/user.dart';
// import 'package:introchat/core/services/database.dart';
// import 'package:introchat/core/services/firestore/intro_service.dart';
// import 'package:introchat/core/utils/constants/colors.dart';
// import 'package:introchat/core/models/custom_contact.dart';
// import 'package:introchat/ui/components/custom_nav_bar.dart';
// import 'package:introchat/ui/components/loading.dart';
// import 'package:introchat/ui/components/record_button.dart';
// import 'package:introchat/ui/components/underline.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:provider/provider.dart';

// class IntroVideo extends StatefulWidget {
//   final List<CustomContact> contacts;

//   IntroVideo({this.contacts});

//   @override
//   _IntroVideoState createState() => _IntroVideoState();
// }

// class _IntroVideoState extends State<IntroVideo> {
//   bool _saving = false;

//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<User>(context);
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: ModalProgressHUD(
//         opacity: 0.5,
//         color: Colors.white,
//         inAsyncCall: _saving,
//         child: SafeArea(
//           child: Column(
//             children: <Widget>[
//               CustomNavBar(),
//               SizedBox(
//                 height: screenWidth,
//                 width: screenWidth,
//                 child: Container(
//                   color: Colors.white,
//                 ),
//               ),
//               Underline(),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 30.0,
//                   horizontal: 0.0,
//                 ),
//                 child: Text(
//                   'Tell them why you want them to connect',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 17.0,
//                   ),
//                 ),
//               ),
//               Underline(),
//               SizedBox(
//                 height: 65.0,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   VideoTimer(),
//                   RecordButton(),
//                   GestureDetector(
//                     child: SendIntro(),
//                     onTap: () async {
//                       setState(() {
//                         _saving = true;
//                       });

//                       // IntroService introService = IntroService();
//                       // await introService.createIntro(user.uid, widget.contacts);
//                       setState(() {
//                         _saving = false;
//                       });

//                       // Flushbar(
//                       //   titleText: Text(
//                       //     "Intro Sent",
//                       //     textAlign: TextAlign.center,
//                       //     style: TextStyle(
//                       //       color: ConstantColors.FLUSH_TEXT,
//                       //       fontSize: 18.0,
//                       //       fontWeight: FontWeight.w700,
//                       //     ),
//                       //   ),
//                       //   messageText: Text(
//                       //     '',
//                       //   ),
//                       //   duration: Duration(seconds: 2),
//                       //   flushbarPosition: FlushbarPosition.TOP,
//                       //   flushbarStyle: FlushbarStyle.GROUNDED,
//                       //   backgroundColor: ConstantColors.FLUSH_BACKGROUND,
//                       // )..show(context);
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SendIntro extends StatelessWidget {
//   const SendIntro({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       // width: 110,
//       decoration: new BoxDecoration(
//         color: ConstantColors.PRIMARY_BUTTON,
//         borderRadius: BorderRadius.all(
//           Radius.circular(20.0),
//         ),
//       ),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             vertical: 0.0,
//             horizontal: 15.0,
//           ),
//           child: Text(
//             'Send Intro',
//             style: TextStyle(color: Colors.white, fontSize: 20.0),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class VideoTimer extends StatelessWidget {
//   const VideoTimer({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       width: 110,
//       decoration: new BoxDecoration(
//         color: ConstantColors.HIGHLIGHT_BLUE,
//         borderRadius: BorderRadius.all(
//           Radius.circular(20.0),
//         ),
//       ),
//       child: Center(
//         child: Text(
//           '00:00:00',
//           style: TextStyle(color: Colors.white, fontSize: 20.0),
//         ),
//       ),
//     );
//   }
// }
