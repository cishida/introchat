import 'package:flutter/material.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/constants/strings.dart';
import 'package:introchat/ui/components/loading.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:provider/provider.dart';

class SocialList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socialAccounts = ConstantStrings.SOCIAL_ACCOUNTS;
    final userProfile = Provider.of<UserProfile>(context);

    if (userProfile != null && userProfile.socialAccounts == null) {
      userProfile.socialAccounts = {};
    }

    return (userProfile == null)
        ? Loading()
        : Column(
            children: List.generate(socialAccounts.length, (index) {
              return GestureDetector(
                onTap: () async {
                  String link = await Navigator.of(context).push(
                    new MaterialPageRoute<String>(
                      builder: (BuildContext context) {
                        return SocialDialog(
                            socialAccount: socialAccounts[index],
                            link: userProfile
                                .socialAccounts[socialAccounts[index]]);
                      },
                      fullscreenDialog: true,
                    ),
                  );

                  // Set or update link in map if user confirmed
                  if (link != null) {
                    userProfile.socialAccounts.update(
                      socialAccounts[index],
                      (existingValue) => link,
                      ifAbsent: () => link,
                    );
                  }

                  // Remove account if no link
                  if (link == '') {
                    userProfile.socialAccounts.remove(socialAccounts[index]);
                  }
                  userProfile.update();
                },
                child: SocialRow(
                  name: socialAccounts[index],
                  link:
                      userProfile.socialAccounts[socialAccounts[index]] ?? null,
                  showUnderline: index != socialAccounts.length - 1,
                ),
              );
            }),
          );
  }
}

class SocialRow extends StatefulWidget {
  const SocialRow({
    Key key,
    this.name,
    this.link,
    this.showUnderline = true,
  }) : super(key: key);

  final String name;
  final String link;
  final bool showUnderline;

  @override
  _SocialRowState createState() => _SocialRowState();
}

class _SocialRowState extends State<SocialRow> {
  Widget _buildIcon() {
    if (widget.link != '' && widget.link != null) {
      return Icon(
        Icons.check,
        color: ConstantColors.ONBOARDING_TEXT,
      );
    } else {
      return Icon(
        Icons.add,
        color: ConstantColors.ONBOARDING_TEXT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 35.0,
          ),
          child: Stack(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/${widget.name}.png',
                    height: 32,
                    width: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 13.0),
                    child: Text(
                      // Capitalize first letter
                      widget.name[0].toUpperCase() + widget.name.substring(1),
                      style: TextStyle(
                        color: ConstantColors.ONBOARDING_TEXT,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 6.0,
                ),
                alignment: Alignment.centerRight,
                child: _buildIcon(),
              ),
            ],
          ),
        ),
        widget.showUnderline ? Underline() : Container(),
      ],
    );
  }
}

class SocialDialog extends StatefulWidget {
  const SocialDialog({
    Key key,
    this.socialAccount,
    this.link,
  }) : super(key: key);

  final String socialAccount;
  final String link;

  @override
  SocialDialogState createState() => new SocialDialogState();
}

class SocialDialogState extends State<SocialDialog> {
  String _link = '';

  @override
  void initState() {
    super.initState();
    if (widget.link != null && widget.link != '') {
      setState(() {
        _link = widget.link;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String hintText;
    switch (widget.socialAccount) {
      case 'linkedin':
      case 'facebook':
        hintText = 'Paste Profile Link';
        break;
      case 'youtube':
        hintText = 'Paste Channel Link';
        break;
      default:
        hintText = 'Enter Username';
    }
    return new Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 60.0,
              padding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 28.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
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
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(_link);
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 32.0,
              ),
              child: TextFormField(
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.fromLTRB(
                    30.0,
                    20.0,
                    30.0,
                    20.0,
                  ),
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: ConstantColors.CHAT_TIMESTAMP,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  prefixIcon: Container(
                    width: 50.0,
                    margin: EdgeInsets.only(left: 6.0, right: 11.0),
                    child: Image.asset(
                      'assets/images/${widget.socialAccount}.png',
                      height: 32,
                      width: 32,
                    ),
                  ),
                ),
                initialValue: widget.link,
                onChanged: (text) {
                  setState(() {
                    _link = text;
                  });
                },
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Text(
              'www.${widget.socialAccount}.com/$_link',
              style: TextStyle(
                color: ConstantColors.ONBOARDING_TEXT,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
