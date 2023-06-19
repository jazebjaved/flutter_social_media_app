import 'package:flutter/material.dart';

import '../misc/global_variable.dart';

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
    // ChatApi().getFirebaseMessagingToken();
    // Provider.of<UserProvider>(context, listen: false).refreshUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<NotifyFeedCountProvider>(context, listen: true)
    //     .getNotifyFeedList();

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
