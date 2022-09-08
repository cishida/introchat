import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/connection_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/ui/components/buttons/button_primary.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/flush/flush.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:provider/provider.dart';

class BlockConfirmation extends StatelessWidget {
  final UserProfile userProfile;

  BlockConfirmation({this.userProfile});

  @override
  Widget build(BuildContext context) {
    UserProfile currentUserProfile = Provider.of<UserProfile>(context);
    return Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 13.0,
                      right: 28.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(null);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 80.0,
                ),
                StandardCard(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 25.0,
                            // horizontal: 50.0,
                          ),
                          child: Text(
                            'Blocking this person means you won’t receive their messages or introductions, and you won’t be able to send them any either. You can restore the chat later from your Account settings.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ConstantColors.ONBOARDING_TEXT,
                              fontSize: 17.0,
                              height: 1.5,
                            ),
                          ),
                        ),
                        ButtonPrimary(
                          text: 'Confirm',
                          onPressed: () async {
                            ConnectionService connectionService =
                                ConnectionService();
                            await connectionService.blockConnection(
                              currentUserProfile.uid,
                              userProfile.uid,
                            );
                            String flushText = 'Connection Blocked';
                            Navigator.popUntil(context,
                                ModalRoute.withName(ConstantRoutes.Root));
                            Flush.createFlush(flushText)..show(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Underline(),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //     vertical: 25.0,
                //     horizontal: 50.0,
                //   ),
                //   child: Container(
                //     height: 60.0,
                //     width: double.infinity,
                //     child: MaterialButton(
                //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //       color: ConstantColors.HIGHLIGHT_BLUE,
                //       child: Text(
                //         "Confirm",
                //         style: TextStyle(
                //           color: Colors.white,
                //         ),
                //       ),
                //       onPressed: () async {
                //         ConnectionService connectionService =
                //             ConnectionService();
                //         await connectionService.blockConnection(
                //           currentUserProfile.uid,
                //           userProfile.uid,
                //         );
                //         String flushText = 'Connection Blocked';
                //         Navigator.popUntil(
                //             context, ModalRoute.withName(ConstantRoutes.Root));
                //         Flush.createFlush(flushText)..show(context);
                //       },
                //       shape: const StadiumBorder(),
                //     ),
                //   ),
                // ),
                // Underline(),
                // SizedBox(
                //   height: 60.0,
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //       vertical: 40.0,
                //       horizontal: 0.0,
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: <Widget>[
                //         Image.asset(
                //           'assets/images/arrow-circle.png',
                //           height: 24.0,
                //           width: 24.0,
                //         ),
                //         SizedBox(
                //           width: 5.0,
                //         ),
                //         Text(
                //           "Go Back",
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 17.0,
                //             fontWeight: FontWeight.normal,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
