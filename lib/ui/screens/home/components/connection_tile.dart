import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/connection_service.dart';
import 'package:introchat/core/services/firestore/introchat_contact_service.dart';
import 'package:introchat/core/utils/formatters/timestampFormatter.dart';
import 'package:introchat/ui/components/images/user_image.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:introchat/ui/screens/home/chats/conversation/conversation_view.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/utils/constants/colors.dart';

class ConnectionTile extends StatefulWidget {
  final Connection connection;
  final String currentUserUid;
  ConnectionTile({
    this.connection,
    this.currentUserUid,
  });

  @override
  _ConnectionTileState createState() => _ConnectionTileState();
}

class _ConnectionTileState extends State<ConnectionTile> {
  UserProfile userProfile;
  ConnectionService connectionService = ConnectionService();

  _updateConnection() {
    connectionService
        .getConnectionUserProfile(widget.connection.uid)
        .then((profile) {
      if (profile.preuser != null && profile.preuser) {
        IntrochatContactService introchatContactService =
            IntrochatContactService();
        introchatContactService
            .getIntrochatContactFromEmail(profile.email)
            .then((introchatContact) {
          profile.displayName =
              introchatContact.getCorrectDisplayName(widget.currentUserUid);

          if (mounted) {
            setState(() {
              userProfile = profile;
            });
          }
        });
      } else {
        if (mounted) {
          setState(() {
            userProfile = profile;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _updateConnection();
  }

  @override
  void didUpdateWidget(ConnectionTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    _updateConnection();
  }

  @override
  Widget build(BuildContext context) {
    FontWeight lastMessageWeight;
    Color lastMessageColor;
    bool notify = false;
    if (((widget.connection.status != ConnectionStatus.pending) &&
            (widget.connection.lastViewed == null ||
                widget.connection.lastViewed.microsecondsSinceEpoch <
                    widget.connection.mostRecentActivity
                        .microsecondsSinceEpoch)) &&
        (userProfile?.preuser == null || !userProfile.preuser)) {
      lastMessageWeight = FontWeight.normal;
      lastMessageColor = ConstantColors.SECONDARY_TEXT;
      notify = true;
    } else {
      lastMessageWeight = FontWeight.normal;
      lastMessageColor = ConstantColors.SECONDARY_TEXT;
    }

    if (userProfile == null) {
      notify = false;
    }

    var timestampFormatter = TimestampFormatter();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (widget.connection.status != ConnectionStatus.pending &&
            (userProfile?.preuser == null || !userProfile.preuser)) {
          Navigator.of(context).push(
            MaterialPageRoute<String>(
              builder: (BuildContext context) {
                return ConversationView(
                  connection: widget.connection,
                );
              },
              fullscreenDialog: true,
            ),
          );
        }
      },
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
              6.0,
              12.0,
              25.0,
              12.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // widget.connection.unseenNotificationCount > 0
                notify
                    ? Badge(
                        badgeContent: Container(),
                        toAnimate: false,
                        badgeColor: ConstantColors.HIGHLIGHT_BLUE,
                        position: BadgePosition.topRight(
                          top: -9.0,
                          right: -9.5,
                        ),
                        padding: EdgeInsets.all(
                          7.0,
                        ),
                      )
                    : Container(),
                SizedBox(
                  // width: widget.connection.unseenNotificationCount > 0
                  width: notify ? 6.0 : 20.0,
                ),
                UserImage(
                  url: userProfile?.photoUrl,
                  radius: 30.0,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              (userProfile?.displayName != null &&
                                      userProfile?.displayName != '')
                                  ? userProfile?.displayName
                                  : (widget.connection.temporaryDisplayName ??
                                      'Loading...'),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              timestampFormatter.getChatTileTime(
                                  widget.connection.mostRecentActivity),
                              // timeago.format(
                              //     widget.connection.mostRecentActivity.toDate(),
                              //     locale: 'en_short'),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: ConstantColors.SECONDARY_TEXT,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        userProfile == null
                            ? 'Loading...'
                            :
                            // userProfile.preuser ||
                            //         widget.connection.status ==
                            //             ConnectionStatus.pending
                            //     ? 'Connecting'
                            //     : widget.connection.lastMessage,
                            ((userProfile?.preuser != null &&
                                        userProfile.preuser) ||
                                    widget.connection.status ==
                                        ConnectionStatus.pending
                                ? 'Connecting'
                                : widget.connection.lastMessage),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: lastMessageColor,
                          fontSize: 16.0,
                          fontWeight: lastMessageWeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ListTile(
            //   // contentPadding: Ed,
            //   onTap: () {
            //     if (widget.connection.status != ConnectionStatus.pending &&
            //         (userProfile?.preuser == null || !userProfile.preuser)) {
            //       Navigator.of(context).push(
            //         MaterialPageRoute<String>(
            //           builder: (BuildContext context) {
            //             return ConversationView(
            //               connection: widget.connection,
            //             );
            //           },
            //           fullscreenDialog: true,
            //         ),
            //       );
            //     }
            //   },
            //   leading: UserImage(url: userProfile.photoUrl, radius: 30.0),
            //   title: Text(
            //     userProfile?.displayName ??
            //         (widget.connection.temporaryDisplayName ?? 'Loading...'),
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontWeight: FontWeight.w600,
            //       fontSize: 18.0,
            //     ),
            //     overflow: TextOverflow.ellipsis,
            //     maxLines: 1,
            //   ),
            //   subtitle: Text(
            //     (userProfile?.preuser != null && userProfile.preuser) ||
            //             widget.connection.status == ConnectionStatus.pending
            //         ? 'Connecting'
            //         : widget.connection.lastMessage,
            //     overflow: TextOverflow.ellipsis,
            //     maxLines: 1,
            //     style: TextStyle(
            //       color: lastMessageColor,
            //       fontSize: 18.0,
            //       fontWeight: lastMessageWeight,
            //     ),
            //   ),
            //   trailing: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
            //       Padding(
            //         padding: EdgeInsets.only(top: 8.0),
            //       ),
            //       Text(
            //         timeago.format(widget.connection.mostRecentActivity.toDate(),
            //             locale: 'en_short'),
            //         textAlign: TextAlign.right,
            //         style: TextStyle(
            //           color: ConstantColors.SECONDARY_TEXT,
            //           fontSize: 16.0,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ),
          Underline(),
        ],
      ),
    );
  }
}
