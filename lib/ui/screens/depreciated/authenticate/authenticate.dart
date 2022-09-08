import 'package:flutter/material.dart';
import 'package:introchat/ui/screens/depreciated/authenticate/components/phone_input.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // child: PhoneInput(),
        );
  }
}

// enum AuthenticateScreen {
//   intro,
//   signIn,
// }

// class Authenticate extends StatefulWidget {
//   @override
//   _AuthenticateState createState() => _AuthenticateState();
// }

// class _AuthenticateState extends State<Authenticate> {
//   AuthenticateScreen _currentScreen = AuthenticateScreen.intro;

//   void showScreen(AuthenticateScreen screen) {
//     setState(() {
//       _currentScreen = screen;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: _buildCurrentScreen(),
//     );
//   }

//   Widget _buildCurrentScreen() {
//     switch (_currentScreen) {
//       case AuthenticateScreen.intro:
//         return Landing();
//       case AuthenticateScreen.signIn:
//         return SignIn();
//       // other screens as cases...
//       default:
//         throw Exception('invalid screen');
//     }
//   }
// }
