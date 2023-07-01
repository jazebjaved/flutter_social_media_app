import 'package:cached_network_image/cached_network_image.dart';
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
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: snap.photoUrl,
                    width: 48,
                    height: 48,
                    placeholder: (context, url) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
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
                      style: const TextStyle(
                          color: Color.fromARGB(255, 123, 121, 121)),
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
