import 'package:flutter/material.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/loading.dart';
// import 'package:introchat/ui/screens/onboarding/components/onboarding_contacts.dart';
// import 'package:introchat/ui/screens/onboarding/components/onboarding_name.dart';
import 'package:introchat/ui/screens/onboarding/components/onboarding_nav_bar.dart';
import 'package:introchat/ui/screens/onboarding/components/onboarding_notifications.dart';
import 'package:introchat/ui/screens/onboarding/components/onboarding_social.dart';
import 'package:provider/provider.dart';
// import 'package:introchat/ui/screens/onboarding/components/onboarding_nav_bar.dart';

//TODO: Whole onboarding flow should be cleaned up
class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

// TODO: DRY up animations
class _OnboardingState extends State<Onboarding> {
  int index = 0;

  void _backPressed() {
    setState(() {
      if (index > 0) {
        index--;
      }
    });
  }

  _nextPressed(User user, UserProfile userProfile) {
    setState(() {
      if (index == 1) {
        userProfile.onboarded = true;
      }

      userProfile.update();

      if (index < 1) {
        index++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final userProfile = Provider.of<UserProfile>(context);

    return (userProfile == null)
        ? Loading()
        : Scaffold(
            backgroundColor: ConstantColors.PRIMARY,
            // appBar: AppBar(),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    OnboardingNavBar(
                      index: index,
                      backPressed: _backPressed,
                      nextPressed: () => _nextPressed(user, userProfile),
                    ),
                    OnboardingForm(index: index),
                  ],
                ),
              ),
            ),
          );
  }
}

class OnboardingForm extends StatefulWidget {
  const OnboardingForm({
    Key key,
    @required this.index,
  }) : super(key: key);

  final int index;

  @override
  _OnboardingFormState createState() => _OnboardingFormState();
}

class _OnboardingFormState extends State<OnboardingForm>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    _controller.reset();
    _controller.forward();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Pull animation to parent to DRY up
    switch (widget.index) {
      case 0:
        return FadeTransition(
          opacity: animation,
          child: OnboardingNotifications(),
        );
        break;
      // case 1:
      //   return FadeTransition(
      //     opacity: animation,
      //     child: OnboardingContacts(),
      //   );
      //   break;
      case 1:
        return FadeTransition(
          opacity: animation,
          child: OnboardingSocial(),
        );
        break;
      default:
        return OnboardingNotifications();
    }
  }
}
