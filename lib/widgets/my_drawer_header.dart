import 'package:first_app/widgets/change_theme_widget_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as UserModel;

import '../provider/theme_provider.dart';
import '../provider/user_provider.dart';

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({super.key});

  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    UserModel.User? user = Provider.of<UserProvider>(
      context,
    ).getUser;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(user!.photoUrl),
                      ),
                    ),
                  ),
                  Text(
                    user.username,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: Column(
                // shows the list of menu drawer
                children: [
                  // menuItem(
                  //   "News Feed",
                  //   Icons.dashboard_outlined,
                  //   const NewsFeed(),
                  // ),
                  // menuItem("Profile", Icons.people_alt_outlined,
                  //     ProfileScreen(uid: user.uid)),
                  // menuItem("Theme Appearnce", Icons.settings_outlined,
                  //     const NewsFeed()),
                  // menuItem("Notifications", Icons.notifications_outlined,
                  //     const NotificationFeedScreen()),

                  const Divider(),
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Theme',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                        ChangeThemeButtonWidget()
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      side: BorderSide(
                        width: 3.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: () {
                      // Respond to button press
                    },
                    icon: const Icon(
                      Icons.logout,
                      size: 22,
                    ),
                    label: const Text(
                      "Log Out",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuItem(String title, IconData icon, Widget pageroute) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => pageroute));
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
