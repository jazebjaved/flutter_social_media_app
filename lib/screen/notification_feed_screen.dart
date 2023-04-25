import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/models/notification_feed.dart';
import 'package:first_app/models/post.dart';
import 'package:first_app/provider/notification_feed_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import '../models/user.dart' as UserModel;

import '../provider/user_provider.dart';
import '../resources/firestore_method.dart';
import '../widgets/my_drawer_header.dart';
import '../widgets/notification_feed_card.dart';

class NotificationFeedScreen extends StatelessWidget {
  const NotificationFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel.User? user = Provider.of<UserProvider>(
      context,
    ).getUser;
    List<NotifyFeed> notifyList = [];

    // Stream<List<DocumentSnapshot>> combine2Streams(
    //     Stream<QuerySnapshot> stream1, Stream<QuerySnapshot> stream2) {
    //   return Rx.combineLatest2(
    //       stream1,
    //       stream2,
    //       (QuerySnapshot a, QuerySnapshot b) =>
    //           List.from(a.docs)..addAll(b.docs));
    // }

    // Stream<List<DocumentSnapshot>> combine2Streams(
    //     Stream<QuerySnapshot> stream1,
    //     Stream<QuerySnapshot> stream2,
    //     Stream<QuerySnapshot> stream3) {
    //   return Rx.combineLatest3(
    //       stream1,
    //       stream2,
    //       stream3,
    //       (QuerySnapshot a, QuerySnapshot b, QuerySnapshot c) =>
    //           List.from(a.docs)
    //             ..addAll(b.docs)
    //             ..addAll(c.docs));
    // }

//     growableList[0] = 'G';
// print(growableList); // [G, B]
// growableList.add('X');
// growableList.addAll({'C', 'B'});
// print(growableList);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Latest Notifications',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      drawer: MyHeaderDrawer(),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: StreamBuilder(
          stream: FirestoreMethods().gettNotifyFeed(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  'no data',
                ),
              );
            }
            final data = snapshot.data?.docs;

            notifyList = data
                    ?.map((e) =>
                        NotifyFeed.fromJson(e.data() as Map<String, dynamic>))
                    .toList() ??
                [];

            notifyList.sort((a, b) => b.timestamp.compareTo(a.timestamp));

            // int count = notifyList
            //     .where(
            //       (element) => element.read == '',
            //     )
            //     .length;
            // print(count);
            // Timer.periodic(const Duration(seconds: 1),
            //     (Timer t) => notifyFeedProvider.getNotifyFeedList(count));
            //   List<NotifyFeed> unreadMessageCount = [];

            //  var newlist = notifyList.retainWhere((element) => element.read == '');

            //   unreadMessageCount =  List.from(notifyList);
            //   print(unreadMessageCount.length);

            return Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: notifyList.length,
                  itemBuilder: (context, index) => NotificationFeedCard(
                    notifyFeed: notifyList[index],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
