import 'package:flutter/material.dart';
import '../models/user.dart' as UserModel;

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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
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
                CircleAvatar(
                  backgroundColor: Color.fromARGB(65, 158, 158, 158),
                  radius: 20,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.people_outline_sharp,
                      color: const Color(0xFFEE0F38),
                    ),
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
