import 'package:first_app/provider/comments_provider.dart';
import 'package:first_app/provider/user_provider.dart';
import 'package:first_app/resources/chatApi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../misc/global_variable.dart';
import '../provider/notification_feed_provider.dart';
import '../provider/theme_provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout(
      {super.key,
      required this.webScreenLayout,
      required this.mobileScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    ChatApi().getFirebaseMessagingToken();
    Provider.of<UserProvider>(context, listen: false).refreshUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<NotifyFeedCountProvider>(context, listen: true)
        .getNotifyFeedList();

    return LayoutBuilder(
      builder: (context, Constraints) {
        if (Constraints.maxWidth > webScreenSize) {
          return widget.webScreenLayout;
        }
        return widget.mobileScreenLayout;
      },
    );
  }
}
