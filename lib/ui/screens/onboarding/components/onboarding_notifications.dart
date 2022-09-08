import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:notification_permissions/notification_permissions.dart';
// import 'package:simple_permissions/simple_permissions.dart';

class OnboardingNotifications extends StatefulWidget {
  @override
  _OnboardingNotificationsState createState() =>
      _OnboardingNotificationsState();
}

class _OnboardingNotificationsState extends State<OnboardingNotifications> {
  PermissionStatus permissionStatus;

  @override
  void initState() {
    super.initState();
    getNotificationsPermission().then((status) {
      setState(() {
        permissionStatus = status;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 150.0,
        ),
        StandardCard(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Welcome to Introchat! Please tap below to turn on notifications — they'll help you get introductions much faster.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ConstantColors.ONBOARDING_TEXT,
                    fontSize: 17.0,
                    height: 1.5,
                  ),
                ),
                SizedBox(
                  height: 26.0,
                ),
                Container(
                  height: 70.0,
                  child: SizedBox.expand(
                    child: RawMaterialButton(
                      fillColor: permissionStatus == PermissionStatus.granted
                          ? ConstantColors.BUTTON_PRIMARY
                          : ConstantColors.BUTTON_PRIMARY,
                      splashColor: Colors.blueAccent,
                      shape: const StadiumBorder(),
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Text(
                              permissionStatus == PermissionStatus.granted
                                  ? 'Notifications On'
                                  : 'Turn On Notifications',
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              right: 30.0,
                            ),
                            alignment: Alignment.centerRight,
                            child: permissionStatus != PermissionStatus.granted
                                ? null
                                : Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        NotificationPermissions.requestNotificationPermissions(
                          iosSettings: const NotificationSettingsIos(
                            sound: true,
                            badge: true,
                            alert: true,
                          ),
                          openSettings: true,
                        ).then((_) {
                          // when finished, check the permission status
                          getNotificationsPermission().then((status) {
                            setState(() {
                              permissionStatus = status;
                            });
                          });
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Text(
        //   "Welcome to Introchat! Please tap below to turn on notifications — they'll help you make and receive introductions much faster.",
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     color: ConstantColors.ONBOARDING_TEXT,
        //     fontSize: 17.0,
        //     height: 1.5,
        //   ),
        // ),
        // SizedBox(
        //   height: 30.0,
        // ),
        // Divider(
        //   height: 1.0,
        //   color: Colors.white,
        // ),
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 50.0),
        //   child: Container(
        //     height: 70.0,
        //     child: SizedBox.expand(
        //       child: RawMaterialButton(
        //         fillColor: permissionStatus == PermissionStatus.granted
        //             ? ConstantColors.ACCEPTED_BUTTON
        //             : ConstantColors.PRIMARY_BUTTON,
        //         splashColor: Colors.blueAccent,
        //         shape: const StadiumBorder(),
        //         child: Stack(
        //           children: <Widget>[
        //             Center(
        //               child: Text(
        //                 permissionStatus == PermissionStatus.granted
        //                     ? 'Notifications On'
        //                     : 'Turn On Notifications',
        //                 maxLines: 1,
        //                 style: TextStyle(color: Colors.white, fontSize: 16.0),
        //               ),
        //             ),
        //             Container(
        //               padding: EdgeInsets.only(
        //                 right: 30.0,
        //               ),
        //               alignment: Alignment.centerRight,
        //               child: permissionStatus != PermissionStatus.granted
        //                   ? null
        //                   : Icon(
        //                       Icons.check,
        //                       color: Colors.white,
        //                     ),
        //             ),
        //           ],
        //         ),
        //         onPressed: () {
        //           NotificationPermissions.requestNotificationPermissions(
        //             iosSettings: const NotificationSettingsIos(
        //               sound: true,
        //               badge: true,
        //               alert: true,
        //             ),
        //             openSettings: true,
        //           ).then((_) {
        //             // when finished, check the permission status
        //             getNotificationsPermission().then((status) {
        //               setState(() {
        //                 permissionStatus = status;
        //               });
        //             });
        //           });
        //         },
        //       ),
        //     ),
        //   ),
        // ),
        // Divider(
        //   height: 1.0,
        //   color: Colors.white,
        // ),
      ],
    );
  }

  Future<PermissionStatus> getNotificationsPermission() =>
      NotificationPermissions.getNotificationPermissionStatus();

  // Future<bool> checkNotificationsPermission() =>
  //     SimplePermissions.checkPermission(Permission.ReadContacts);

  // Future<PermissionStatus> getNotificationsPermission() =>
  //     SimplePermissions.requestPermission(Permission.ReadContacts);
}
