import 'package:flutter/material.dart';
// import 'package:introchat/core/models/custom_contact.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/user_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/empty_image.dart';
import 'package:introchat/ui/components/images/user_image.dart';
// import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:provider/provider.dart';

typedef ContactCallback = void Function(IntrochatContact);

class ContactTile extends StatefulWidget {
  final IntrochatContact contact;
  final ContactCallback onContactSelect;
  final bool connected;
  final bool showEmail;
  final bool showUnderline;

  ContactTile({
    this.contact,
    this.onContactSelect,
    this.connected = false,
    this.showEmail = true,
    this.showUnderline = true,
  });

  @override
  _ContactTileState createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  @override
  void initState() {
    super.initState();

    // UserService userService = UserService();
    // if (widget.contact.userId != null) {
    //   userService.getUserProfile(widget.contact.userId).then((userProfile) {
    //     setState(() {
    //       _userProfile = userProfile;
    //     });
    //   });
    // }
  }

  Widget _showIcon() {
    if (widget.contact.isChecked) {
      return Icon(
        Icons.check,
        color: Colors.white,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProfile userProfile = Provider.of<UserProfile>(context);

    return GestureDetector(
      onTap: () {
        widget.onContactSelect(widget.contact);
      },
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 9.0,
              horizontal: 18.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UserImage(
                  radius: 32.0,
                  url: widget.contact.photoUrl,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.contact.getCorrectDisplayName(userProfile.uid),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    !widget.showEmail
                        ? null
                        : Text(
                            widget.connected
                                ? 'Connected'
                                : widget.contact.email,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: ConstantColors.SECONDARY_TEXT,
                              fontSize: 16.0,
                            ),
                          ),
                  ],
                ),
                Spacer(),
                _showIcon(),
              ],
            ),
          ),
          widget.showUnderline
              ? Padding(
                  padding: EdgeInsets.only(
                    left: 99.0,
                    right: 18.0,
                  ),
                  child: Underline(),
                )
              : Container(),
          // ListTile(
          //   contentPadding: EdgeInsets.symmetric(
          //     vertical: 10.0,
          //     horizontal: 10.0,
          //   ),
          //   leading: UserImage(
          //     radius: 32.0,
          //     url: widget.contact.photoUrl,
          //   ),
          //   title: Text(
          //     widget.contact.getCorrectDisplayName(userProfile.uid),
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 18.0,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          //   subtitle: !widget.showEmail
          //       ? null
          //       : Text(
          //           widget.connected ? 'Connected' : widget.contact.email,
          //           style: TextStyle(
          //             color: ConstantColors.SECONDARY_TEXT,
          //             fontSize: 16.0,
          //           ),
          //         ),
          //   trailing: _showIcon(),
          //   onTap: () {
          //     widget.onContactSelect(widget.contact);
          //   },
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left: 75.0),
          //   child: Underline(),
          // ),
        ],
      ),
    );
  }
}
