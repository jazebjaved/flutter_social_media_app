import 'package:flutter/material.dart';
import '../models/user.dart' as UserModel;
import '../screen/profile_screen.dart';

class AddFriendCard extends StatelessWidget {
  final UserModel.User snap;
  const AddFriendCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
          top: 12,
          bottom: 12,
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(snap.photoUrl),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snap.username,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      snap.bio,
                      style:
                          TextStyle(color: Color.fromARGB(255, 123, 121, 121)),
                    ),
                  ],
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: snap.uid,
                      ),
                    ),
                  ),
                  child: const Text(
                    'View Profile',
                    style: TextStyle(color: Color(0xFFEE0F38)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    ]);
  }
}
