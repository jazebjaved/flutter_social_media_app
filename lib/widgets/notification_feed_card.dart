import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/notification_feed.dart';
import '../resources/firestore_method.dart';
import '../screen/profile_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationFeedCard extends StatelessWidget {
  final NotifyFeed notifyFeed;
  const NotificationFeedCard({super.key, required this.notifyFeed});

  @override
  Widget build(BuildContext context) {
    if (notifyFeed.read.isEmpty) {
      FirestoreMethods().updateCommentReadStatus(notifyFeed);
      FirestoreMethods().updateFollowReadStatus(notifyFeed);
      FirestoreMethods().updateLikeReadStatus(notifyFeed);
    }
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      elevation: 3,
      shadowColor: Color(0xFFEE0F38),
      child: Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 15,
          bottom: 15,
        ),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: notifyFeed.userId,
                      ),
                    ),
                  ),
                  child: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(notifyFeed.userProfileImg)),
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(TextSpan(
                        text: notifyFeed.username,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        children: <InlineSpan>[
                          if (notifyFeed.type == 'comment')
                            const TextSpan(
                              text: ' Replied on your post',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 123, 121, 121)),
                            ),
                          if (notifyFeed.type == 'like')
                            const TextSpan(
                              text: ' Like your Post',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 123, 121, 121)),
                            ),
                          if (notifyFeed.type == 'follow')
                            const TextSpan(
                              text: ' Start Following you',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 123, 121, 121)),
                            ),
                        ])),
                    // Text(
                    //   '${notifyFeed.username} ${notifyFeed.type == 'like' ? 'liked your post' : 'commented your post'}',
                    //   style: const TextStyle(
                    //       fontSize: 16, fontWeight: FontWeight.w600),
                    // ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      timeago.format(notifyFeed.timestamp),
                      style:
                          TextStyle(color: Color.fromARGB(255, 123, 121, 121)),
                    ),
                  ],
                ),
                const Spacer(),
                if (notifyFeed.type != 'follow')
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: notifyFeed.postImg,
                      height: 55,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  )
                // TextButton(
                //   onPressed: () => Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) => ProfileScreen(
                //         uid: notifyFeed.userId,
                //       ),
                //     ),
                //   ),
                //   child: const Text(
                //     'View Profile',
                //     style: TextStyle(color: Color(0xFFEE0F38)),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
