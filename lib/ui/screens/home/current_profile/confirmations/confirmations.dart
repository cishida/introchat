import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:introchat/core/models/intro/intro.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/intro_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/formatters/timestampFormatter.dart';
import 'package:introchat/ui/components/images/user_image.dart';
import 'package:introchat/ui/components/skeletons/contacts_skeleton.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:introchat/ui/screens/home/current_profile/confirmations/intro_view/intro_view.dart';
import 'package:provider/provider.dart';

class Confirmations extends StatefulWidget {
  @override
  _ConfirmationsState createState() => _ConfirmationsState();
}

class _ConfirmationsState extends State<Confirmations> {
  bool _isLoading = false;
  List<Intro> _intros = [];
  IntroService _introService = IntroService();

  _getIntros() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    final userProfile = Provider.of<UserProfile>(context, listen: false);
    _intros = await _introService.getAllIntros(userProfile.uid);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _getIntros();
  }

  @override
  Widget build(BuildContext context) {
    // final userProfile = Provider.of<UserProfile>(context);
    bool _disabled = false;

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
                    'All Confirmations',
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
              child: _isLoading
                  ? ContactsSkeleton()
                  : ListView.builder(
                      itemCount: _intros.length,
                      itemBuilder: (context, index) {
                        String firstDisplayName =
                            _intros[index].toUserProfiles.first.displayName ??
                                'Loading...';
                        String secondDisplayName =
                            _intros[index].toUserProfiles.last.displayName ??
                                'Loading...';
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 0.0,
                                horizontal: 15.0,
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<String>(
                                      builder: (BuildContext context) {
                                        return IntroView(_intros[index]);
                                      },
                                      fullscreenDialog: true,
                                    ),
                                  );
                                },
                                leading: UserImage(
                                  url: _intros[index]
                                      .toUserProfiles
                                      .first
                                      .photoUrl,
                                  radius: 25.0,
                                ),
                                title: Text(
                                  (firstDisplayName +
                                      '  •  ' +
                                      secondDisplayName),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                subtitle: Text(
                                  TimestampFormatter.getDateFromTimestamp(
                                    _intros[index].created,
                                    dateFormat:
                                        DateFormat("MMMM dd, yyyy 'at' h:mm a"),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: ConstantColors.SECONDARY_TEXT,
                                    fontSize: 16.0,
                                  ),
                                ),
                                // child: Column(
                                //   children: <Widget>[
                                //     Padding(
                                //       padding: const EdgeInsets.symmetric(
                                //         vertical: 10.0,
                                //         horizontal: 35.0,
                                //       ),
                                //       child: Row(
                                //         children: <Widget>[
                                //           UserImage(
                                //             url: _intros[index]
                                //                 .toUserProfiles
                                //                 .first
                                //                 .photoUrl,
                                //             radius: 30.0,
                                //           ),
                                //           Column(
                                //             children: <Widget>[
                                //               Text(
                                // _intros[index]
                                //         .toUserProfiles
                                //         .first
                                //         .displayName +
                                //     ' • ' +
                                //     _intros[index]
                                //         .toUserProfiles
                                //         .last
                                //         .displayName,
                                //                 overflow: TextOverflow.ellipsis,
                                //                 maxLines: 1,
                                //                 style: TextStyle(
                                //                   color: Colors.white,
                                //                   fontSize: 18.0,
                                //                 ),
                                //               ),
                                //               Text('Intro placeholder'),
                                //             ],
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //     Underline(),
                                //   ],
                                // ),
                              ),
                            ),
                            Underline(),
                          ],
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
