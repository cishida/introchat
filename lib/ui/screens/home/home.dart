import 'dart:async';
import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/auth/auth_service.dart';
import 'package:introchat/core/services/firestore/introchat_contact_service.dart';
import 'package:introchat/core/services/firestore/user_service.dart';
import 'package:introchat/ui/components/loading.dart';
import 'package:introchat/ui/screens/home/current_profile/current_profile.dart';
import 'package:introchat/ui/screens/home/chats/chats.dart';
import 'package:introchat/ui/screens/home/feed/feed.dart';
import 'package:introchat/ui/screens/home/search/search.dart';
import 'package:introchat/ui/screens/onboarding/onboarding.dart';
import 'package:provider/provider.dart';
import 'package:introchat/core/utils/constants/colors.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  IntrochatContactService introchatContactService = IntrochatContactService();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        if (index >= 0 && index < 4) {
          _selectedIndex = index;
        }
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    Timer.periodic(Duration(minutes: 1), (Timer t) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.resumed) {
      print('resumed');
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context, listen: false);
    // final user = Provider.of<User>(context);
    final userProfile = Provider.of<UserProfile>(context);
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    UserService _userService = UserService();

    // _timer = (const Duration(seconds: 10), () {
    //   if (userProfile == null) {
    //     _auth.signOut();
    //   }
    // });

    //

    if (userProfile == null) {
      // _auth.signOut();
      return Loading();
    } else if (userProfile.onboarded == null || !userProfile.onboarded) {
      return Onboarding();
    } else {
      _firebaseMessaging.getToken().then((String token) {
        if (token != null && userProfile != null) {
          _userService.addToken(userProfile.uid, token);
        }
      });

      List<Widget> _widgetOptions = <Widget>[
        Feed(changeTab: _onItemTapped),
        Chats(changeTab: _onItemTapped),
        Search(),
        CurrentProfile(),
      ];

      final Widget chatsIcon = userProfile.unseenNotificationCount > 0
          ? Badge(
              badgeContent: Text(''),
              toAnimate: false,
              badgeColor: ConstantColors.HIGHLIGHT_BLUE,
              position: BadgePosition.topRight(
                top: -9.0,
                right: -9.5,
              ),
              padding: EdgeInsets.all(
                7.0,
              ),
              child: ImageIcon(
                AssetImage(
                  'assets/images/chats-gray.png',
                ),
                size: 25.0,
              ),
            )
          : ImageIcon(
              AssetImage(
                'assets/images/chats-gray.png',
              ),
              size: 25.0,
            );

      return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: ConstantColors.UNDERLINE,
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: ConstantColors.PRIMARY,
            // fixedColor: Colors.white,
            unselectedItemColor: ConstantColors.UNSELECTED_ICON,
            selectedItemColor: Colors.white,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: Colors.transparent,
                icon: ImageIcon(
                  AssetImage(
                    'assets/images/home-gray.png',
                  ),
                  size: 22.0,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: chatsIcon,
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage(
                    'assets/images/search-gray.png',
                  ),
                  size: 22.0,
                ),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage(
                    'assets/images/profile-gray.png',
                  ),
                  size: 22.0,
                ),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      );

      // return VisibilityDetector(
      //   key: Key('home'),
      //   onVisibilityChanged: (visibility) async {
      //     if ((userProfile.homeOnboarding == null ||
      //             !userProfile.homeOnboarding) &&
      //         visibility.visibleFraction == 0) {
      //       await userProfile.setHomeOnboarding();
      //     }
      //   },
      //   child: Scaffold(
      //     backgroundColor: ConstantColors.PRIMARY,
      //     body: SafeArea(
      //       child: Column(
      //         children: <Widget>[
      //           IntroBar(),
      //           Underline(),
      //           Expanded(
      //             child: ConnectionList(),
      //           ),
      //         ],
      //       ),
      //     ),
      //     // floatingActionButton: GestureDetector(
      //     //   onTap: () {
      //     //     Navigator.of(context).push(
      //     //       MaterialPageRoute<String>(
      //     //         builder: (BuildContext context) {
      //     //           return ChooseIntroType();
      //     //         },
      //     //         fullscreenDialog: true,
      //     //       ),
      //     //     );
      //     //   },
      //     //   child: Container(
      //     //     height: 60.0,
      //     //     width: 60.0,
      //     //     child: FittedBox(
      //     //       child: Image.asset(
      //     //         'assets/images/intro-icon.png',
      //     //         height: 60.0,
      //     //         width: 60.0,
      //     //       ),
      //     //     ),
      //     //   ),
      //     // ),
      //   ),
      // );
    }
  }
}
