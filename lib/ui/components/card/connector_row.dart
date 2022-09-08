import 'package:flutter/material.dart';
import 'package:introchat/ui/components/empty_image.dart';
import 'package:introchat/ui/components/images/user_image.dart';

class ConnectorRow extends StatelessWidget {
  const ConnectorRow({
    Key key,
    @required this.graphicUrl,
    @required this.photoUrl,
    @required this.displayName,
  }) : super(key: key);

  final String graphicUrl;
  final String photoUrl;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Row(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              graphicUrl,
              height: 33,
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          UserImage(
            radius: 21.0,
            url: photoUrl,
            bordered: false,
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                displayName ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
