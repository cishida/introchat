import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.30),
              // Image.asset(
              //   'assets/images/logo-white.png',
              //   height: 116,
              //   width: 116,
              // ),
              // SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo-white.png',
                    height: 60,
                    width: 60,
                  ),
                  Text(
                    'Introchat',
                    style: TextStyle(
                      fontSize: 50.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 23.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: GestureDetector(
                  onTap: () async {
                    await authService.signInWithGoogle();
                  },
                  child: Image.asset(
                    'assets/images/google-sign-in.png',
                    height: 60.0,
                  ),
                ),
              ),
              // SignInButton(
              //   text: 'Sign in with Gmail',
              //   onPressed: () async {
              //     await authService.signInWithGoogle();
              //     // Navigator.pushNamed(context, ConstantRoutes.Authenticate);
              //   },
              // ),
              SizedBox(height: 24.0),
              Text(
                'By signing in you agree to our Terms & Privacy Policy.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: ConstantColors.SECONDARY_TEXT,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
