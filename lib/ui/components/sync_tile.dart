import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/buttons/button_primary.dart';
import 'package:introchat/ui/components/underline.dart';

class SyncTile extends StatelessWidget {
  const SyncTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: ButtonPrimary(
                text: 'Sync with Google Contacts',
                color: ConstantColors.SECONDARY,
              )),
        ],
      ),
    );
  }
}
