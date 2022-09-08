import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/ui/components/buttons/button_primary.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/card/tip_row.dart';

class TipsCard extends StatelessWidget {
  const TipsCard({
    Key key,
    this.onPressed,
    @required this.title,
    @required this.tips,
    this.changeTab,
  }) : super(key: key);

  final Function onPressed;
  final String title;
  final List<String> tips;
  final Function(int) changeTab;

  List<Widget> _buildItems(BuildContext context) {
    List<Widget> widgets = [];

    // Add title widget
    widgets.add(
      Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 32.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    );

    // Add tip rows
    for (var tip in tips) {
      widgets.add(TipRow(text: tip));
    }

    // If onPressed, add sync button
    if (onPressed != null) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(
            15.0,
            25.0,
            15.0,
            0.0,
          ),
          child: ButtonPrimary(
            text: 'Sync with Google Contacts',
            onPressed: onPressed,
          ),
        ),
      );
    }

    if (changeTab != null) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(
            15.0,
            25.0,
            15.0,
            0.0,
          ),
          child: ButtonPrimary(
              text: 'Add Teammate',
              onPressed: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(ConstantRoutes.Root),
                );
                changeTab(2);
              }),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 60.0,
        bottom: 30.0,
      ),
      child: StandardCard(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 30.0,
            bottom: 30.0,
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            children: _buildItems(context),
          ),
        ),
      ),
    );
  }
}
