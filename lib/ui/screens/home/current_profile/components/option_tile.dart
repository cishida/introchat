import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/underline.dart';

class OptionTile extends StatelessWidget {
  final String option;
  final bool leftPadding;
  OptionTile({
    this.option,
    this.leftPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return StandardCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 0.0,
            ),
            child: Text(
              option,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Row(
            //   children: <Widget>[
            //     SizedBox(
            //       width: MediaQuery.of(context).size.width * 0.28 +
            //           (leftPadding ? 20.0 : 0.0),
            //     ),
            //     Image.asset(
            //       'assets/images/${option.toLowerCase().replaceAll(' ', '-')}-icon.png',
            //       height: 32,
            //       width: 32,
            //     ),
            //     SizedBox(
            //       width: 16.0,
            //     ),
            //     Text(
            //       option,
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 18.0,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ],
            // ),
          ),
          // Underline(),
        ],
      ),
    );
  }
}
