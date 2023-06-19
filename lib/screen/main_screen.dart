import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/provider/notification_feed_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '/responsive/mobile_screen_layout.dart';
import '/screen/login_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<NotifyFeedCountProvider>(context, listen: true)
        .getNotifyFeedList();

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MobileScreenLayout();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
        return const Login();
      },
    );
  }
}
