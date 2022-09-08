import 'package:flutter/material.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/connection_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/flush/flush.dart';
import 'package:introchat/ui/components/loading.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:introchat/ui/screens/home/current_profile/account/blocked_list/components/blocked_connection_tile.dart';
import 'package:provider/provider.dart';

class BlockedList extends StatefulWidget {
  @override
  _BlockedListState createState() => _BlockedListState();
}

class _BlockedListState extends State<BlockedList> {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);
    final userProfile = Provider.of<UserProfile>(context);
    final connections = Provider.of<List<Connection>>(context);
    bool _disabled = false;

    if (connections == null) {
      return Loading();
    } else {
      List<Connection> blockedConnections = connections
          .where((connection) => connection.status == ConnectionStatus.blocked)
          .toList();
      return Scaffold(
        backgroundColor: ConstantColors.PRIMARY,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 28.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Spacer(),
                    Text(
                      'Block List',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            if (!_disabled) {
                              setState(() {
                                _disabled = true;
                              });
                              Navigator.pop(context);
                              setState(() {
                                _disabled = false;
                              });
                            }
                          },
                          child: Text(
                            'Done',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Underline(),
              Expanded(
                child: ListView.builder(
                  itemCount: blockedConnections.length,
                  itemBuilder: (context, index) {
                    return BlockedConnectionTile(
                      connection: blockedConnections[index],
                      unblock: () async {
                        String flushText = 'Connection Unblocked';
                        ConnectionService connectionService =
                            ConnectionService();
                        await connectionService.unblockConnection(
                            userProfile.uid, blockedConnections[index].uid);
                        Flush.createFlush(flushText)..show(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
