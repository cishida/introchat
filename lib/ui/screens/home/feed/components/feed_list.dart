import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/intro/intro.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/auth/auth_service.dart';
import 'package:introchat/core/services/auth/firebase_auth_service.dart';
import 'package:introchat/core/services/firestore/feed_service.dart';
import 'package:introchat/core/services/firestore/introchat_contact_service.dart';
import 'package:introchat/core/services/firestore/user_service.dart';
import 'package:introchat/core/utils/constants/strings.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/card/tip_row.dart';
import 'package:introchat/ui/components/card/tips_card.dart';
import 'package:introchat/ui/components/images/user_image.dart';
import 'package:introchat/ui/components/loading.dart';
import 'package:introchat/ui/screens/home/components/profile/profile.dart';
import 'package:introchat/ui/screens/home/feed/components/feed_tile.dart';
import 'package:introchat/ui/screens/home/search/request_connection/request_connection.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FeedList extends StatefulWidget {
  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  FeedService _feedService = FeedService();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool _isLoading = false;
  List _feedObjects = [];
  User _currentUser;

  void _onRefresh() async {
    // TODO: make refresh only load objects coming after most recent loaded
    // don't reload everything
    _loadFeedObjects();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  _loadFeedObjects() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    if (_currentUser == null) {
      AuthService auth = FirebaseAuthService();
      _currentUser = await auth.currentUser();
    }

    _feedObjects = await _feedService.getAllFeedObjects(_currentUser.uid);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFeedObjects();
  }

  @override
  Widget build(BuildContext context) {
    // final intros = Provider.of<List<Intro>>(context);

    return _isLoading
        ? Loading()
        : SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropHeader(),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("pull up load");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("release to load more");
                } else {
                  body = Text("No more Data");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemCount: _feedObjects.length + 1,
              itemBuilder: (context, index) {
                if (index == _feedObjects.length) {
                  return TipsCard(
                    title: ConstantStrings.HOME_TIPS_TITLE,
                    tips: ConstantStrings.HOME_TIPS,
                  );
                }

                if (_feedObjects[index] is Intro) {
                  return Padding(
                    padding: EdgeInsets.only(top: (index == 0 ? 8.0 : 0)),
                    child: FeedTile(
                      intro: _feedObjects[index],
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.only(top: (index == 0 ? 8.0 : 0)),
                    child:
                        ContactJoinedTile(userId: _feedObjects[index].userId),
                  );
                }

                // if (_feedObjects[index].type == 'contactJoined')
              },
            ),
          );
  }
}

class ContactJoinedTile extends StatefulWidget {
  const ContactJoinedTile({
    Key key,
    @required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  _ContactJoinedTileState createState() => _ContactJoinedTileState();
}

class _ContactJoinedTileState extends State<ContactJoinedTile> {
  UserProfile _userProfile;
  IntrochatContact _introchatContact;
  UserService _userService = UserService();

  void _loadUserProfile() async {
    UserProfile currentUserProfile =
        Provider.of<UserProfile>(context, listen: false);
    UserProfile userProfile = await _userService.getUserProfile(widget.userId);
    IntrochatContact introchatContact =
        await IntrochatContactService(uid: currentUserProfile.uid)
            .getIntrochatContactFromUser(userProfile.uid);
    if (mounted) {
      setState(() {
        _userProfile = userProfile;
        _introchatContact = introchatContact;
      });
    }
  }

  _goToConnection(Connection connection) async {
    UserProfile userProfile = await _userService.getUserProfile(connection.uid);

    Navigator.of(context).push(
      MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return Profile(
            userProfile: userProfile,
            connection: connection,
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  _goToRequestConnection(IntrochatContact introchatContact) async {
    UserProfile userProfile =
        await _userService.getUserProfile(introchatContact.userId);

    Navigator.of(context).push(
      MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return RequestConnection(
            userProfile: userProfile,
            introchatContact: introchatContact,
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  _onContactSelect() async {
    final connections = Provider.of<List<Connection>>(context, listen: false);

    bool connected = false;
    for (var connection in connections) {
      if (connection.uid == widget.userId) {
        connected = true;
        if (connection.status != ConnectionStatus.pending) {
          await _goToConnection(connection);
        }
        break;
      }
    }
    if (!connected) {
      await _goToRequestConnection(_introchatContact);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    // if (_userProfile == null) {
    //   return Loading();
    // } else {
    String text = _userProfile == null
        ? 'Loading...'
        : 'Your contact ' + _userProfile?.displayName + ' is here.';
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onContactSelect,
      child: StandardCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 15.0,
          ),
          child: Row(
            children: [
              UserImage(
                radius: 30.0,
                url: _userProfile?.photoUrl,
                bordered: false,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 30.0,
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // }
  }
}

class HomeTipsCard extends StatelessWidget {
  const HomeTipsCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 60.0,
            bottom: 80.0,
          ),
          child: StandardCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30.0,
                horizontal: 20.0,
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    '🏠  Home',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TipRow(
                    text:
                        'Your Home tab shows you all the introductions that people in your network make and receive.',
                  ),
                  TipRow(
                    text:
                        'The Intro button in the top right corner lets you introduce people and ask for intros when you need them.',
                  ),
                  TipRow(
                    text:
                        'Try tapping Chats or Search below to learn more about how the app works and start making connections.',
                  ),
                ],
              ),
            ),
          ),
        ),
        // Spacer(),
      ],
    );
  }
}

// class HomeTipRow extends StatelessWidget {
//   const HomeTipRow({
//     Key key,
//     @required this.text,
//   }) : super(key: key);

//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         top: 15.0,
//         left: 20.0,
//         right: 20.0,
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 17.0,
//         ),
//       ),
//     );
//   }
// }
