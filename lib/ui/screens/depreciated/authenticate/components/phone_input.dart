// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:introchat/core/services/auth/auth_service.dart';
// import 'package:introchat/core/utils/constants/routes.dart';
// import 'package:introchat/ui/components/loading.dart';
// import 'package:introchat/core/utils/constants/colors.dart';
// import 'package:introchat/core/utils/formatters/us_number_formatter.dart';
// import 'package:provider/provider.dart';

// class PhoneInput extends StatefulWidget {
//   @override
//   _PhoneInputState createState() => _PhoneInputState();
// }

// class _PhoneInputState extends State<PhoneInput> {
//   final _formKey = GlobalKey<FormState>();

//   bool loading = false;

//   // Text field state
//   String phone = '';
//   String error = '';

//   void _backPressed() {
//     Navigator.pop(context);
//   }

//   _nextPressed(AuthService authService) async {
//     if (_formKey.currentState.validate()) {
//       var strippedPhone = phone.replaceAll(RegExp('[^0-9]'), '');
//       authService.sendVerificationCode('+1' + strippedPhone);
//       Navigator.pushNamed(context, ConstantRoutes.PhoneVerification);
//     } else {
//       print('Invalid form');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context, listen: false);

//     return loading
//         ? Loading()
//         : Scaffold(
//             backgroundColor: ConstantColors.PRIMARY,
//             // appBar: AppBar(
//             //   backgroundColor: ConstantColors.PRIMARY,
//             //   elevation: 0.0,
//             //   title: Text('Sign in to Introchat'),
//             // ),
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
//                         GestureDetector(
//                           onTap: () => _nextPressed(authService),
//                           child: Text(
//                             'Next',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18.0,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       vertical: 0.0,
//                       horizontal: 30.0,
//                     ),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: <Widget>[
//                           SizedBox(
//                             height: 10.0,
//                           ),
//                           Text(
//                             "By entering your number you agree to receive verification texts. Standard rates apply.",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: ConstantColors.ONBOARDING_TEXT,
//                               fontSize: 17.0,
//                               height: 1.5,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 40.0,
//                           ),
//                           TextFormField(
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 16.0,
//                             ),
//                             decoration: InputDecoration(
//                               filled: true,
//                               fillColor: Colors.white,
//                               contentPadding: EdgeInsets.symmetric(
//                                 vertical: 20.0,
//                                 horizontal: 30.0,
//                               ),
//                               hintText: 'Phone number',
//                               hintStyle: TextStyle(
//                                 color: ConstantColors.MESSAGE_PLACEHOLDER,
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(30.0),
//                                 ),
//                               ),
//                             ),
//                             inputFormatters: <TextInputFormatter>[
//                               LengthLimitingTextInputFormatter(14),
//                               WhitelistingTextInputFormatter.digitsOnly,
//                               BlacklistingTextInputFormatter
//                                   .singleLineFormatter,
//                               UsNumberTextInputFormatter(),
//                             ],
//                             validator: (val) => val.length < 14
//                                 ? 'Enter valid phone number'
//                                 : null,
//                             onChanged: (val) {
//                               setState(() => phone = val);
//                             },
//                           ),
//                           SizedBox(
//                             height: 10.0,
//                           ),
//                           Container(
//                             height: 60.0,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(30.0),
//                               border: Border.all(
//                                 color: Colors.white,
//                                 style: BorderStyle.solid,
//                                 width: 1.0,
//                               ),
//                             ),
//                             child: DropdownButtonHideUnderline(
//                               child: ButtonTheme(
//                                 alignedDropdown: true,
//                                 child: DropdownButton<String>(
//                                   isDense: true,
//                                   isExpanded: true,
//                                   items: [
//                                     DropdownMenuItem(
//                                       value: "1",
//                                       child: Text(
//                                         "United States",
//                                       ),
//                                     ),
//                                   ],
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 16.0,
//                                   ),
//                                   hint: Text(
//                                     'United States',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   onChanged: (_) {},
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//   }
// }
