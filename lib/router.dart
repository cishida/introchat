import 'package:flutter/material.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/ui/components/loading.dart';
import 'package:introchat/ui/screens/depreciated/new_chat/new_chat_contacts/new_chat_contacts.dart';
import 'package:introchat/ui/screens/home/components/profile/block_confirmation/block_confirmation.dart';
import 'package:introchat/ui/screens/home/current_profile/account/blocked_list/blocked_list.dart';
import 'package:introchat/ui/screens/home/components/email_invite/email_invite.dart';
import 'package:introchat/ui/screens/home/home.dart';
import 'package:introchat/ui/screens/home/chats/conversation/conversation_view.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/intro/choose_contacts/choose_contacts.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/intro/contact_confirmation/contact_confirmation.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/intro/intro_empty/intro_empty.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/request/request_ask/request_ask.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/request/request_contacts/request_contacts.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/request/request_empty/request_empty.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/request/request_empty_contacts/request_empty_contacts.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/request/request_message/request_message.dart';
import 'package:introchat/ui/screens/landing/landing.dart';
import 'package:introchat/ui/screens/home/current_profile/account/account.dart';
import 'package:introchat/ui/screens/home/current_profile/current_profile.dart';
import 'package:introchat/ui/screens/home/components/profile/profile.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ConstantRoutes.Landing:
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => Landing());
    // case ConstantRoutes.Authenticate:
    //   return MaterialPageRoute(
    //       settings: RouteSettings(name: settings.name),
    //       builder: (context) => Authenticate());
    // case ConstantRoutes.PhoneVerification:
    //   return MaterialPageRoute(
    //       settings: RouteSettings(name: settings.name),
    //       builder: (context) => PhoneVerification());
    case ConstantRoutes.Home:
      return MaterialPageRoute(
        settings: RouteSettings(name: settings.name),
        builder: (context) => Home(),
      );
    case ConstantRoutes.Conversation:
      final Connection args = settings.arguments as Connection;
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => ConversationView(connection: args));
    case ConstantRoutes.CurrentProfile:
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => CurrentProfile());
    case ConstantRoutes.Profile:
      final UserProfile args = settings.arguments as UserProfile;
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => Profile(userProfile: args));
    case ConstantRoutes.EmailInvite:
      final IntrochatContact args = settings.arguments as IntrochatContact;
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => EmailInvite(contact: args));
    case ConstantRoutes.Account:
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => Account());
    case ConstantRoutes.IntroEmpty:
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => IntroEmpty());
    case ConstantRoutes.ChooseContacts:
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => ChooseContacts());
    case ConstantRoutes.ContactConfirmation:
      final List<IntrochatContact> args =
          settings.arguments as List<IntrochatContact>;
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => ContactConfirmation(contacts: args));
    // case ConstantRoutes.IntroVideo:
    //   final List<CustomContact> args =
    //       settings.arguments as List<CustomContact>;
    //   return MaterialPageRoute(
    //       settings: RouteSettings(name: settings.name), builder: (context) => IntroVideo(contacts: args));
    case ConstantRoutes.RequestEmpty:
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => RequestEmpty());
    case ConstantRoutes.RequestEmptyContacts:
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => RequestEmptyContacts());
    case ConstantRoutes.RequestContacts:
      final Map args = settings.arguments;
      final List<Connection> connections =
          args['connections'] as List<Connection>;
      final Function(int) changeTab = args['changeTab'];

      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => RequestContacts(
                connections: connections,
                changeTab: changeTab,
              ));
    case ConstantRoutes.RequestAsk:
      final IntrochatContact args = settings.arguments as IntrochatContact;
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => RequestAsk(introchatContact: args));
    case ConstantRoutes.RequestMessage:
      final RequestMessageArgs args = settings.arguments as RequestMessageArgs;
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => RequestMessage(requestMessageArgs: args));
    case ConstantRoutes.NewChatContacts:
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => NewChatContacts());
    case ConstantRoutes.BlockConfirmation:
      final UserProfile args = settings.arguments as UserProfile;
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => BlockConfirmation(userProfile: args));
    case ConstantRoutes.BlockedList:
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => BlockedList());
    default:
      return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => Loading());
  }
}
