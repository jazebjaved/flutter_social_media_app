import 'package:first_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';
import '../provider/user_provider.dart';
import '../screen/add_post_screen.dart';
import '../models/user.dart' as UserModel;

class addPostCard extends StatelessWidget {
  const addPostCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    UserModel.User? user = Provider.of<UserProvider>(
      context,
    ).getUser;
    String? url = user?.photoUrl;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      elevation: 18,
      shadowColor: Theme.of(context).colorScheme.primary,
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 4),
        child: Column(
          children: [
            Row(
              children: [
                url == null
                    ? const SizedBox
                        .shrink() // If it's missing, display an empty box
                    : CircleAvatar(
                        radius: 22, backgroundImage: NetworkImage(url)),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "what's on your mind, ${user?.username}? ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.all(11),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const AddPostScreen(),
                    ),
                  );
                },
                onHover: (value) {},
                child: const Text(
                  'Post It!',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
