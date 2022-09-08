import 'dart:async';

import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/colors.dart';

class SyncLoader extends StatefulWidget {
  SyncLoader({
    Key key,
  }) : super(key: key);

  @override
  _SyncLoaderState createState() => _SyncLoaderState();
}

class _SyncLoaderState extends State<SyncLoader> {
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _updateProgress();
  }

  void _updateProgress() {
    Timer.periodic(Duration(milliseconds: 10), (Timer t) {
      if (mounted) {
        setState(() {
          if (_progressValue < 0.99) {
            _progressValue += ((1 - _progressValue) * 0.0005);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      body: SafeArea(
        child: Center(
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Image.asset(
                      'assets/images/dark-logo.png',
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      Text(
                        'Syncing with Google Contacts...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 50.0,
                        ),
                        child: LinearProgressIndicator(
                          value: _progressValue,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
