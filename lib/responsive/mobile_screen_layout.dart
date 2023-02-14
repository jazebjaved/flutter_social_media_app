import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/misc/global_variable.dart';
import 'package:first_app/screen/add_post_screen.dart';
import 'package:first_app/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../screen/news_feed_screen.dart';
import '../screen/profile_screen.dart';
import '../screen/search_screen.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  PageController controller = PageController(initialPage: 2);
  var selected = 2;

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
              ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
            ]),
            bottomNavigationBar: StylishBottomBar(
              items: [
                AnimatedBarItems(
                  selectedColor: const Color(0xFFEE0F38),
                  icon: const Icon(
                    Icons.home_outlined,
                    color: Color(0xFFEE0F38),
                  ),
                  title: const Text('Home'),
                ),
                AnimatedBarItems(
                  selectedColor: const Color(0xFFEE0F38),
                  icon: const Icon(Icons.search_outlined),
                  title: const Text('Find Friends'),
                ),
                AnimatedBarItems(
                  selectedColor: const Color(0xFFEE0F38),
                  icon: const Icon(
                    Icons.notification_important_outlined,
                  ),
                  title: const Text('Cabin jj kk'),
                ),
                AnimatedBarItems(
                  selectedColor: const Color(0xFFEE0F38),
                  icon: const Icon(Icons.person_outline),
                  title: const Text('Cabin'),
                ),
              ],

              elevation: 50,
              fabLocation: StylishBarFabLocation.center,
              hasNotch: true,
              iconSize: 28,
              iconStyle: IconStyle.animated,
              barStyle: BubbleBarStyle.vertical,
              // bubbleFillStyle: BubbleFillStyle.fill,
              // bubbleFillStyle: BubbleFillStyle.outlined,
              opacity: 0.5,
              currentIndex: selected,
              onTap: (index) {
                setState(() {
                  selected = index!;
                  controller.jumpToPage(index);
                });
              },
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
