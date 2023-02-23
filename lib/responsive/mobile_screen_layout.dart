import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/misc/global_variable.dart';
import 'package:first_app/resources/chatApi.dart';
import 'package:first_app/screen/add_post_screen.dart';
import 'package:first_app/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylish_bottom_bar/helpers/bottom_bar.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../provider/user_provider.dart';
import '../screen/news_feed_screen.dart';
import '../screen/profile_screen.dart';
import '../screen/search_screen.dart';
import '../models/user.dart' as UserModel;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  PageController controller = PageController(initialPage: 0);
  var selected = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Scaffold(
            body: PageView(controller: controller, children: [
              const NewsFeed(),
              const SearchScreen(),
              const ChatScreen(),
              ProfileScreen(uid: ChatApi().user.uid),
            ]),
            bottomNavigationBar: StylishBottomBar(
              items: [
                BottomBarItem(
                  selectedColor: const Color(0xFFEE0F38),
                  icon: const Icon(
                    Icons.home_outlined,
                    color: Color(0xFFEE0F38),
                  ),
                  title: const Text('Home'),
                ),
                BottomBarItem(
                  selectedColor: const Color(0xFFEE0F38),
                  icon: const Icon(Icons.search_outlined),
                  title: const Text('Find Friends'),
                ),
                BottomBarItem(
                  selectedColor: const Color(0xFFEE0F38),
                  icon: const Icon(
                    Icons.notification_important_outlined,
                  ),
                  title: const Text('Cabin jj kk'),
                ),
                BottomBarItem(
                  selectedColor: const Color(0xFFEE0F38),
                  icon: const Icon(Icons.person_outline),
                  title: const Text('Cabin'),
                ),
              ],
              elevation: 50,
              fabLocation: StylishBarFabLocation.center,
              hasNotch: true,
              currentIndex: selected,
              onTap: (index) {
                setState(() {
                  selected = index!;
                  controller.jumpToPage(index);
                });
              },
              option: AnimatedBarOptions(
                // iconSize: 32,
                barAnimation: BarAnimation.fade,
                iconStyle: IconStyle.animated,
                // opacity: 0.3,
              ),
            ),
            // ignore: prefer_const_constructors
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFFEE0F38),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const AddPostScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add_a_photo_outlined),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          ),
        ),
      ],
    );
  }
}
