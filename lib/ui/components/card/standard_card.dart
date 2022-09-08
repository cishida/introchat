import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/colors.dart';

class StandardCard extends StatefulWidget {
  const StandardCard({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _StandardCardState createState() => _StandardCardState();
}

class _StandardCardState extends State<StandardCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 3.0,
        margin: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom: 5.0,
          // top: 10.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: ConstantColors.SECONDARY,
        child: widget.child,
      ),
    );
  }
}
