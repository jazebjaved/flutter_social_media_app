import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/resources/firestore_method.dart';
import 'package:first_app/widgets/comment_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class commentsScreen extends StatefulWidget {
  final snap;
  const commentsScreen({super.key, this.snap});

  @override
  State<commentsScreen> createState() => _commentsScreenState();
}

class _commentsScreenState extends State<commentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments: '),
      ),
      bottomNavigationBar: SizedBox(
        height: kToolbarHeight,
        child: Container(
          padding: const EdgeInsets.only(top: 5),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 2.0, color: Color(0xFFEE0F38)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: TextField(
              scrollPhysics:
                  const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              controller: _commentController,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  icon: CircleAvatar(
                    maxRadius: 17,
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  suffixIcon: InkWell(
                    onTap: () async {
                      await FirestoreMethods().PostComment(
                          user.photoUrl,
                          user.username,
                          user.uid,
                          widget.snap['postId'],
                          _commentController.text);
                      setState(() {
                        _commentController.text = "";
                      });
                    },
                    child: const Icon(
                      Icons.send_outlined,
                    ),
                  ),
                  hintText: 'Write a Caption.....',
                  hintStyle: const TextStyle(
                    fontSize: 18,
                  )),
              maxLines: 1,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('post')
              .doc(widget.snap['postId'])
              .collection('comments')
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshots.data!.docs.length,
              itemBuilder: ((context, index) => commentCard(
                    snap: snapshots.data!.docs[index].data(),
                  )),
            );
          },
        ),
      ),
    );
  }
}
