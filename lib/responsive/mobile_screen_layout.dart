import 'package:cached_network_image/cached_network_image.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:first_app/resources/chatApi.dart';
import 'package:first_app/screen/add_post_screen.dart';
import 'package:first_app/screen/notification_feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/notification_feed_provider.dart';
import '../provider/user_provider.dart';
import '../screen/news_feed_screen.dart';
import '../screen/profile_screen.dart';
import '../screen/search_screen.dart';
import '../models/user.dart' as UserModel;
import 'package:badges/badges.dart' as badges;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _currentindex = 0;
  List pages = [
    const NewsFeed(),
    const SearchScreen(),
    const AddPostScreen(),
    const NotificationFeedScreen(),
    ProfileScreen(uid: ChatApi().user.uid)
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ChatApi().getFirebaseMessagingToken();
    Provider.of<UserProvider>(context, listen: false).refreshUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel.User? user = Provider.of<UserProvider>(
      context,
    ).getUser;

    String? url = user?.photoUrl;
    print('rebuild');

    return Row(
      children: [
        Expanded(
          child: Scaffold(
              body: pages[_currentindex],
              bottomNavigationBar: ConvexAppBar(
                  color: Theme.of(context).colorScheme.primary,
                  activeColor: Theme.of(context).colorScheme.primary,
                  style: TabStyle.reactCircle,
                  backgroundColor: Theme.of(context).primaryColor,
                  items: [
                    const TabItem(icon: Icons.home, title: 'Feed'),
                    const TabItem(icon: Icons.search, title: ' Friends'),
                    const TabItem(icon: Icons.add, title: 'Add'),
                    TabItem(
                      icon: Consumer<NotifyFeedCountProvider>(
                        builder: (context, count, child) {
                          return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(0.0),
                            child: badges.Badge(
                              showBadge: count.count == 0 ? false : true,
                              badgeStyle: badges.BadgeStyle(
                                  badgeColor:
                                      Theme.of(context).colorScheme.primary),
                              badgeContent: Text(
                                count.count.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              child: Icon(
                                Icons.notifications_none,
                                size: 28,
                                color: _currentindex == 3
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          );
                        },
                      ),
                      title: 'Updates',
                    ),
                    TabItem(
                      icon: url == null
                          ? const SizedBox
                              .shrink() // If it's missing, display an empty box
                          : ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: url,
                                width: 34,
                                height: 34,
                                placeholder: (context, url) => const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ),
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                      title: 'Profile',
                    ),
                  ],
                  initialActiveIndex: 2, //optional, default as 0
                  onTap: (int i) {
                    // if (i == 0) {
                    //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //       builder: (context) => const NewsFeed()));
                    // }
                    setState(() {
                      _currentindex = i;
                    });
                  })),
        )
      ],
    );
  }
}


//  Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (BuildContext context) => const AddPostScreen()











// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:first_app/misc/global_variable.dart';
// import 'package:first_app/resources/chatApi.dart';
// import 'package:first_app/screen/add_post_screen.dart';
// import 'package:first_app/screen/chat_screen.dart';
// import 'package:first_app/screen/notification_feed_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stylish_bottom_bar/helpers/bottom_bar.dart';
// import 'package:stylish_bottom_bar/model/bar_items.dart';
// import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

// import '../provider/notification_feed_provider.dart';
// import '../provider/user_provider.dart';
// import '../screen/news_feed_screen.dart';
// import '../screen/profile_screen.dart';
// import '../screen/search_screen.dart';
// import '../models/user.dart' as UserModel;
// import 'package:badges/badges.dart' as badges;

// class MobileScreenLayout extends StatefulWidget {
//   const MobileScreenLayout({super.key});

//   @override
//   State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
// }

// class _MobileScreenLayoutState extends State<MobileScreenLayout> {
//   PageController controller = PageController(initialPage: 0);
//   var selected = 0;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     UserModel.User? user = Provider.of<UserProvider>(
//       context,
//     ).getUser;

//     String? url = user?.photoUrl;
//     print('rebuild');

//     return Row(
//       children: [
//         Expanded(
//           child: Scaffold(
//             resizeToAvoidBottomInset: false,

//             body: PageView(controller: controller, children: [
//               const NewsFeed(),
//               const SearchScreen(),
//               const NotificationFeedScreen(),
//               ProfileScreen(uid: ChatApi().user.uid),
//             ]),
//             bottomNavigationBar: StylishBottomBar(
//               items: [
//                 BottomBarItem(
//                   selectedColor: Theme.of(context).colorScheme.primary,
//                   icon: const Icon(
//                     Icons.home_outlined,
//                   ),
//                   title: const Text('Home'),
//                 ),
//                 BottomBarItem(
//                   selectedColor: Theme.of(context).colorScheme.primary,
//                   icon: const Icon(Icons.search_outlined),
//                   title: const Text('Find Friends'),
//                 ),
//                 BottomBarItem(
//                   selectedColor: Theme.of(context).colorScheme.primary,
//                   icon: Consumer<NotifyFeedCountProvider>(
//                     builder: (context, count, child) {
//                       return badges.Badge(
//                         showBadge: count.count == 0 ? false : true,
//                         badgeStyle: badges.BadgeStyle(
//                             badgeColor: Theme.of(context).colorScheme.primary),
//                         badgeContent: Text(
//                           count.count.toString(),
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         child: Icon(
//                           Icons.notifications_none_outlined,
//                         ),
//                       );
//                     },
//                   ),
//                   title: const Text('Feeds'),
//                 ),
//                 BottomBarItem(
//                   selectedColor: Theme.of(context).colorScheme.primary,
//                   icon: url == null
//                       ? const SizedBox
//                           .shrink() // If it's missing, display an empty box
//                       : CircleAvatar(
//                           radius: 16, backgroundImage: NetworkImage(url)),
//                   title: const Text('My Profile'),
//                 ),
//               ],
//               elevation: 50,
//               fabLocation: StylishBarFabLocation.center,
//               hasNotch: true,
//               currentIndex: selected,
//               onTap: (index) {
//                 setState(() {
//                   selected = index;
//                   controller.jumpToPage(index);
//                 });
//               },
//               option: AnimatedBarOptions(
//                 // iconSize: 32,
//                 barAnimation: BarAnimation.fade,
//                 iconStyle: IconStyle.animated,
//                 // opacity: 0.3,
//               ),
//             ),
//             // ignore: prefer_const_constructors
//             floatingActionButton: FloatingActionButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (BuildContext context) => const AddPostScreen(),
//                   ),
//                 );
//               },
//               child: const Icon(
//                 Icons.add_a_photo_outlined,
//               ),
//             ),
//             floatingActionButtonLocation:
//                 FloatingActionButtonLocation.centerDocked,
//           ),
//         ),
//       ],
//     );
//   }
// }
