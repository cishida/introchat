import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/auth/auth_service.dart';
import 'package:introchat/core/services/firestore/introchat_contact_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/constants/strings.dart';
import 'package:introchat/ui/components/images/user_image.dart';
import 'package:introchat/ui/components/loading.dart';
import 'package:introchat/ui/components/social/social_list.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:introchat/ui/screens/home/current_profile/account/blocked_list/blocked_list.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  File _image;
  bool _loading = false;
  IntrochatContactService _introchatContactService = IntrochatContactService();

  _launchReportUrl() async {
    var url = //'mailto:support@introchat.com?subject=News&body=Please%20Help';
        Uri.encodeFull(
            'mailto:support@introchat.com?subject=${ConstantStrings.REPORT_SUBJECT}&body=${ConstantStrings.REPORT_BODY}');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
      // throw 'Could not launch $url';
    }
  }

  _launchExportUrl() async {
    var url = //'mailto:support@introchat.com?subject=News&body=Please%20Help';
        Uri.encodeFull(
            'mailto:support@introchat.com?subject=${ConstantStrings.EXPORT_SUBJECT}&body=${ConstantStrings.EXPORT_BODY}');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
      // throw 'Could not launch $url';
    }
  }

  _launchDeleteUrl() async {
    var url = //'mailto:support@introchat.com?subject=News&body=Please%20Help';
        Uri.encodeFull(
            'mailto:support@introchat.com?subject=${ConstantStrings.DELETE_SUBJECT}&body=${ConstantStrings.DELETE_BODY}');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
      // throw 'Could not launch $url';
    }
  }

  void _saveAccount(BuildContext context) {
    Navigator.pop(context);
  }

  Future _getImage(UserProfile userProfile) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (mounted) {
        setState(() {
          _loading = true;
        });
      }

      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child('${userProfile.uid}_profile_image');
      StorageUploadTask uploadTask = ref.putFile(image);
      var downloadUrl =
          await (await uploadTask.onComplete).ref.getDownloadURL();

      userProfile.photoUrl = downloadUrl;

      var introchatContact = await _introchatContactService
          .getIntrochatContactFromUser(userProfile.uid);
      introchatContact.photoUrl = downloadUrl;
      await Future.wait([
        userProfile.update(),
        _introchatContactService.updateIntrochatContact(introchatContact),
      ]);

      setState(() {
        _image = image;
        _loading = false;
      });

      return downloadUrl;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context, listen: false);
    final userProfile = Provider.of<UserProfile>(context);
    bool _disabled = false;

    return _loading
        ? Loading()
        : Scaffold(
            backgroundColor: ConstantColors.PRIMARY,
            // appBar: AppBar(
            //   backgroundColor: ConstantColors.PRIMARY,
            // ),
            body: SafeArea(
              child: SingleChildScrollView(
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
                            'Account',
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 50.0,
                        ),
                        child: Text(
                          'Tap to edit photo',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ConstantColors.ACCOUNT_HIGHLIGHT,
                            fontSize: 17.0,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 0.0),
                      child: GestureDetector(
                        onTap: () async {
                          userProfile.photoUrl = await _getImage(userProfile);
                        },
                        child: UserImage(
                          radius: 62.5,
                          url: userProfile?.photoUrl,
                          bordered: false,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 50.0,
                        ),
                        child: Text(
                          'Social Accounts',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ConstantColors.ACCOUNT_HIGHLIGHT,
                            fontSize: 17.0,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                    Underline(),
                    SocialList(),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _launchReportUrl();
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 50.0,
                          ),
                          child: Text(
                            'Report Someone',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              height: 1.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 50.0,
                      ),
                      child: Underline(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<String>(
                            builder: (BuildContext context) {
                              return BlockedList();
                            },
                            fullscreenDialog: true,
                          ),
                        );
                        // Navigator.pushNamed(
                        // context, ConstantRoutes.BlockedList);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 50.0,
                          ),
                          child: Text(
                            'Block List',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              height: 1.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 50.0,
                      ),
                      child: Underline(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _launchExportUrl();
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 50.0,
                          ),
                          child: Text(
                            'Export Data',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              height: 1.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 50.0,
                      ),
                      child: Underline(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _launchDeleteUrl();
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 50.0,
                          ),
                          child: Text(
                            'Delete Account',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              height: 1.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 50.0,
                      ),
                      child: Underline(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _auth.signOut();
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 50.0,
                          ),
                          child: Text(
                            'Log Out',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              height: 1.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 50.0,
                      ),
                      child: Underline(),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    // RawMaterialButton(
                    //   fillColor: ConstantColors.PRIMARY_BUTTON,
                    //   splashColor: Colors.blueAccent,
                    //   child: Padding(
                    //     padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 54.0),
                    //     child: Text(
                    //       'Log Out',
                    //       maxLines: 1,
                    //       style: TextStyle(color: Colors.white, fontSize: 16.0),
                    //     ),
                    //   ),
                    //   onPressed: () async {
                    //     await _auth.signOut();
                    //   },
                    //   shape: const StadiumBorder(),
                    // ),
                  ],
                ),
              ),
            ),
          );
  }
}
