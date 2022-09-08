import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/colors.dart';
// import 'package:simple_permissions/simple_permissions.dart';

class OnboardingContacts extends StatefulWidget {
  @override
  _OnboardingContactsState createState() => _OnboardingContactsState();
}

class _OnboardingContactsState extends State<OnboardingContacts> {
  bool connectedContacts = false;

  @override
  void initState() {
    super.initState();
    // checkContactsPermission().then((hasPermission) {
    //   if (hasPermission) {
    //     setState(() {
    //       connectedContacts = true;
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 150.0,
        ),
        Text(
          "Great! Now let's put together a list of\npeople you can introduce.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ConstantColors.ONBOARDING_TEXT,
            fontSize: 17.0,
            height: 1.5,
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Divider(
          height: 1.0,
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 50.0),
          child: Container(
            height: 70.0,
            child: SizedBox.expand(
              child: RawMaterialButton(
                fillColor: connectedContacts
                    ? ConstantColors.BUTTON_PRIMARY
                    : ConstantColors.BUTTON_PRIMARY,
                splashColor: Colors.blueAccent,
                shape: const StadiumBorder(),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        connectedContacts ? 'Connected' : 'Connect Contacts',
                        maxLines: 1,
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        right: 30.0,
                      ),
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  // getContactsPermission().then((status) {
                  //   if (status == PermissionStatus.authorized) {
                  //     setState(() {
                  //       connectedContacts = true;
                  //     });
                  //   } else {}
                  // });
                },
              ),
            ),
          ),
        ),
        Divider(
          height: 1.0,
          color: Colors.white,
        ),
      ],
    );
  }

  // Future<bool> checkContactsPermission() =>
  //     SimplePermissions.checkPermission(Permission.ReadContacts);

  // Future<PermissionStatus> getContactsPermission() =>
  //     SimplePermissions.requestPermission(Permission.ReadContacts);
}
