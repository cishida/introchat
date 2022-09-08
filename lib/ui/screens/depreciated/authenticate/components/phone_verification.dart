// import 'package:flutter/material.dart';
// import 'package:introchat/core/services/auth/auth_service.dart';
// import 'package:introchat/core/services/auth/phone_auth.dart';
// import 'package:introchat/core/utils/constants/colors.dart';
// import 'package:introchat/ui/components/loading.dart';
// import 'package:introchat/ui/components/pin_entry_text_field.dart';
// import 'package:provider/provider.dart';

// class PhoneVerification extends StatefulWidget {
//   @override
//   _PhoneVerificationState createState() => _PhoneVerificationState();
// }

// class _PhoneVerificationState extends State<PhoneVerification> {
//   bool loading = false;

//   @override
//   void initState() {
//     FirebasePhoneAuth.phoneAuthState.stream.listen((PhoneAuthState state) =>
//         print('State in phone verification widget: $state'));
//     super.initState();
//   }

//   _backPressed() {
//     print('back');
//     Navigator.pop(context);
//   }

//   // _nextPressed() async {
//   // if (_formKey.currentState.validate()) {
//   // print('next');
//   // } else {
//   // print('Invalid form');
//   // }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context, listen: false);

//     return loading
//         ? Loading()
//         : Scaffold(
//             backgroundColor: ConstantColors.PRIMARY,
//             body: SafeArea(
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     height: 60.0,
//                     padding: EdgeInsets.symmetric(
//                       vertical: 0.0,
//                       horizontal: 28.0,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         GestureDetector(
//                           onTap: _backPressed,
//                           child: Text(
//                             'Back',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18.0,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                         // GestureDetector(
//                         //   onTap: _nextPressed,
//                         //   child: Text(
//                         //     'Next',
//                         //     style: TextStyle(
//                         //       color: Colors.white,
//                         //       fontSize: 18.0,
//                         //       fontWeight: FontWeight.w600,
//                         //     ),
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 93.0,
//                   ),
//                   Text(
//                     "Please enter the code we sent you",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: ConstantColors.ONBOARDING_TEXT,
//                       fontSize: 17.0,
//                       height: 1.5,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 40.0,
//                   ),
//                   PinEntryTextField(
//                     fields: 6,
//                     onSubmit: (String pin) async {
//                       await authService.signInWithPhone(pin);
//                       // FirebasePhoneAuth.signInWithPhoneNumber(smsCode: pin);
//                       // if (result == null) {
//                       //   setState(() {
//                       //     print('Error signing in');
//                       //     loading = false;
//                       //   });
//                       // }
//                     }, // end onSubmit
//                   ),
//                 ],
//               ),
//             ),
//           );
//   }
// }
