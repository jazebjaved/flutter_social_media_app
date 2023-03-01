import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/models/post.dart';
import 'package:first_app/resources/firestore_method.dart';
import 'package:first_app/widgets/addpost_card.dart';
import 'package:first_app/widgets/post_card.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import '../models/user.dart' as UserModel;
import 'package:async/async.dart' show StreamGroup;

import '../provider/user_provider.dart';
import '../resources/chatApi.dart';

class NewsFeed extends StatelessWidget {
  const NewsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    List<Post> _list = [];
    UserModel.User? user = Provider.of<UserProvider>(
      context,
    ).getUser;

    Stream<List<DocumentSnapshot>> combine2Streams(
        Stream<QuerySnapshot> stream1, Stream<QuerySnapshot> stream2) {
      return Rx.combineLatest2(
          stream1,
          stream2,
          (QuerySnapshot a, QuerySnapshot b) =>
              List.from(a.docs)..addAll(b.docs));
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.menu_outlined),
            onPressed: () {},
          ),
          title: Text('Hi, ${user?.username} 😍'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notification_important_outlined),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              const addPostCard(),
              // This Stream is used to get  followers and current user post. it is important as it tool my too much time
              StreamBuilder(
                stream: combine2Streams(
                  FirebaseFirestore.instance
                      .collection('post')
                      .where(
                        'uid',
                        isEqualTo: user?.uid,
                      )
                      .snapshots(),
                  FirebaseFirestore.instance
                      .collection('post')
                      .where(
                        'uid',
                        whereIn: user?.following.isEmpty == true
                            ? ['it works after putting dymmy data. be remeber']
                            : user?.following,
                      )
                      .snapshots(),
                ),
                builder: (context, snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final data = snapshots.data;
                  _list = data?.map((e) => Post.fromJson(e)).toList() ?? [];
                  // _list.add(value);
                  if (_list.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Post yet',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _list.length,
                    itemBuilder: (context, index) => postCard(
                      snap: _list[index],
                      user: ChatApi().user.uid,
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
