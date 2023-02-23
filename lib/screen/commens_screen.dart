import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/resources/firestore_method.dart';
import 'package:first_app/widgets/comment_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as UserModel;

import '../models/post.dart';
import '../provider/user_provider.dart';

class commentsScreen extends StatefulWidget {
  final Post snap;
  const commentsScreen({super.key, required this.snap});

  @override
  State<commentsScreen> createState() => _commentsScreenState();
}

class _commentsScreenState extends State<commentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  UserModel.User? _user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserModel.User user =
        Provider.of<UserProvider>(context, listen: false).getUser!;
    _user = user;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments: '),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('post')
                    .doc(widget.snap.postId)
                    .collection('comments')
                    .orderBy('datePublished', descending: false)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshots) {
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
          ),
          _chatInput(context),
        ],
      ),
    );
  }

  Widget _chatInput(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 5),
                    child: CircleAvatar(
                      maxRadius: 22,
                      backgroundImage: NetworkImage(_user!.photoUrl),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onTap: () {},
                      controller: _commentController,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          hintText: 'type Comment', border: InputBorder.none),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Color(0xFFEE0F38),
                    radius: 24,
                    child: MaterialButton(
                      onPressed: () async {
                        await FirestoreMethods().PostComment(
                            _user!.photoUrl,
                            _user!.username,
                            _user!.uid,
                            widget.snap.postId,
                            _commentController.text);
                        setState(() {
                          _commentController.text = "";
                        });
                      },
                      child: Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
