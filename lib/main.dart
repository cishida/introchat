import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introchat/core/services/auth/auth_service.dart';
import 'package:introchat/core/services/auth/auth_service_adapter.dart';
import 'package:introchat/ui/screens/auth/auth_widget.dart';
import 'package:introchat/ui/screens/auth/auth_widget_builder.dart';
import 'package:provider/provider.dart';
import 'package:introchat/router.dart' as router;
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/ui/theme/style.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthServiceType initialAuthServiceType = AuthServiceType.firebase;

  // String _homeScreenText = "Waiting for token...";
  // String _messageText = "Waiting for message...";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    // _firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true));
    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // setState(() {
        //   _messageText = "Push Messaging message: $message";
        // });
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        // setState(() {
        //   _messageText = "Push Messaging message: $message";
        // });
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        // setState(() {
        //   _messageText = "Push Messaging message: $message";
        // });
        print("onResume: $message");
      },
    );
    // _firebaseMessaging.getToken().then((String token) {
    //   assert(token != null);
    //   // setState(() {
    //   //   _homeScreenText = "Push Messaging token: $token";
    //   // });
    //   print(token);
    // });
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Android
        statusBarBrightness: Brightness.dark, // IOS.
      ),
    );

    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthServiceAdapter(
            initialAuthServiceType: initialAuthServiceType,
          ),
          dispose: (_, AuthService authService) => authService.dispose(),
        ),
      ],
      child: AuthWidgetBuilder(
        builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
          return MaterialApp(
            title: 'Introchat',
            theme: appTheme(),
            home: AuthWidget(userSnapshot: userSnapshot),
            onGenerateRoute: router.generateRoute,
          );
        },
      ),

      // MaterialApp(
      //   title: 'Introchat',
      //   theme: appTheme(),
      //   // home: Wrapper(),
      //   // routes: Routes,
      //   onGenerateRoute: router.generateRoute,
      //   initialRoute: ConstantRoutes.Wrapper,
      // ),
    );

    // StreamProvider<User>.value(
    //   value: AuthService().user,
    //   child:
    // );
  }
}

// class LandingScreen extends StatefulWidget {
//   @override
//   _LandingScreenState createState() => _LandingScreenState();
// }

// class _LandingScreenState extends State<LandingScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       'Test landing screen',
//       style: TextStyle(color: Colors.white),
//     );
//   }

//   @override
//   void didChangeDependencies() {
//     final user = Provider.of<User>(context);

//     // Return Home or Landing widget
//     if (user == null) {
//       Navigator.pushReplacementNamed(context, '/landing');
//     } else {
//       Navigator.pushReplacementNamed(context, '/home');
//     }

//     super.didChangeDependencies();
//   }
// }
