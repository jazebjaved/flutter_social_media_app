import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/models/post.dart';
import 'package:first_app/widgets/addpost_card.dart';
import 'package:first_app/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as UserModel;

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
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('post')
                    .orderBy('datePublished', descending: true)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final data = snapshots.data?.docs;
                  _list = data?.map((e) => Post.fromJson(e)).toList() ?? [];
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshots.data!.docs.length,
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
