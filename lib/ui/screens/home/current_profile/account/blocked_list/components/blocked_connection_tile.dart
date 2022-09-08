import 'package:flutter/material.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/connection_service.dart';
import 'package:introchat/ui/components/images/user_image.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:provider/provider.dart';

// typedef Callback = void Function(void);

class BlockedConnectionTile extends StatefulWidget {
  final Connection connection;
  final Function unblock;

  BlockedConnectionTile({
    this.connection,
    this.unblock,
  });

  @override
  _BlockedConnectionTileState createState() => _BlockedConnectionTileState();
}

class _BlockedConnectionTileState extends State<BlockedConnectionTile> {
  UserProfile userProfile;
  ConnectionService connectionService = ConnectionService();

  _updateConnection() {
    connectionService
        .getConnectionUserProfile(widget.connection.uid)
        .then((profile) {
      if (mounted) {
        setState(() {
          userProfile = profile;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _updateConnection();
  }

  @override
  void didUpdateWidget(BlockedConnectionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateConnection();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserProfile = Provider.of<UserProfile>(context);

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: ListTile(
            leading: UserImage(
              radius: 21.0,
              url: userProfile?.photoUrl,
              bordered: false,
            ),
            // leading:
            title: Text(
              userProfile?.displayName ?? 'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              ),
            ),
            trailing: GestureDetector(
              onTap: () {
                widget.unblock();
              },
              child: Image.asset(
                'assets/images/cancel-button.png',
                height: 24.0,
                width: 24.0,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(0.0),
          child: Underline(),
        ),
      ],
    );
  }
}
