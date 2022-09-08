import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:introchat/core/services/auth/auth_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);

    // Timer(const Duration(seconds: 15), () => _auth.signOut());

    return Container(
      color: ConstantColors.PRIMARY,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SpinKitThreeBounce(
            color: Colors.white,
            size: 30.0,
          ),
        ),
      ),
    );
  }
}
