import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/profile_card.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/request/request_ask/request_ask.dart';

class GetIntroduced extends StatefulWidget {
  const GetIntroduced({
    Key key,
    @required this.userProfile,
  }) : super(key: key);

  final UserProfile userProfile;

  @override
  _GetIntroducedState createState() => _GetIntroducedState();
}

class _GetIntroducedState extends State<GetIntroduced> {
  bool _disabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 60.0,
              child: Padding(
                padding: const EdgeInsets.only(right: 28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
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
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ProfileCard(
              userProfile: widget.userProfile,
              hideLinks: widget.userProfile.preuser,
            ),
            GestureDetector(
              onTap: () async {
                var introchatContacts = await Firestore.instance
                    .collection('introchatContacts')
                    .where('userId', isEqualTo: widget.userProfile.uid)
                    .getDocuments();
                var introchatContact = IntrochatContact.fromJson(
                    introchatContacts.documents.first.documentID,
                    introchatContacts.documents.first.data);
                Navigator.of(context).push(
                  MaterialPageRoute<String>(
                    builder: (BuildContext context) {
                      return RequestAsk(
                        introchatContact: introchatContact,
                      );
                    },
                    fullscreenDialog: true,
                  ),
                );
              },
              child: widget.userProfile.preuser
                  ? Container()
                  : StandardCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/intro-icon.png',
                              height: 32,
                              width: 32,
                            ),
                            SizedBox(width: 16.0),
                            Text(
                              'Get Introduced',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
