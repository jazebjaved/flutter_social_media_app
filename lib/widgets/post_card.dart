import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/provider/comments_provider.dart';
import 'package:first_app/resources/firestore_method.dart';
import 'package:first_app/screen/commens_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as UserModel;

import '../misc/utils.dart';
import '../models/post.dart';
import '../provider/theme_provider.dart';
import '../provider/user_provider.dart';
import '../screen/profile_screen.dart';

class postCard extends StatefulWidget {
  final Post snap;
  final String user;

  const postCard({super.key, required this.snap, required this.user});

  @override
  State<postCard> createState() => _postCardState();
}

class _postCardState extends State<postCard> {
  int postLen = 0;
  bool isloading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future getData() async {
    setState(() {
      isloading = true;
    });
    try {
      //for post lenghth
      var postSnap = await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.snap.postId)
          .collection('comments')
          .get();

      postLen = postSnap.docs.length;

      setState(() {
        postLen = postSnap.docs.length;
      });
    } catch (e) {
      e.toString();
    }
    isloading = false;
  }

  Future<dynamic> _DeleteConfirmation(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: const Center(
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                onPressed: () async {
                  await FirestoreMethods()
                      .deletePost(widget.snap.uid, widget.snap.postId, context);
                  Navigator.of(context).pop();
                },
              ),
              SimpleDialogOption(
                child: const Icon(Icons.cancel_outlined),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ////remember? it wasted your time
    // Provider.of<CommentsProvider>(
    //   context,
    // ).refreshComments(widget.snap['postId']);
    // int? comments = Provider.of<CommentsProvider>(
    //   context,
    // ).getComment;
    UserModel.User? user =
        Provider.of<UserProvider>(context, listen: false).getUser;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      elevation: 18,
      shadowColor: Theme.of(context).colorScheme.primary,
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 4),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: widget.snap.uid,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          widget.snap.photoUrl,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap.username,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            DateFormat.yMMMd()
                                .format(widget.snap.datePublished.toDate()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  backgroundColor:
                      themeProvider.isDarkMode ? null : Colors.red[100],
                  foregroundColor:
                      themeProvider.isDarkMode ? null : Colors.black87,
                  radius: 20,
                  child: IconButton(
                    onPressed: () {
                      _DeleteConfirmation(context);
                    },
                    icon: const Icon(
                      Icons.more_vert,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.snap.description),
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: widget.snap.postPicUrl,
                    placeholder: (context, url) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await FirestoreMethods().likePost(
                            // widget.snap.postId,
                            // widget.user,
                            // widget.snap.likes,
                            // widget.snap.postPicUrl,
                            // user!,
                            // 'like',
                            widget.snap,
                            widget.user,
                            widget.snap.likes,
                            user!,
                            'like');
                      },
                      icon: widget.snap.likes.contains(widget.user)
                          ? const Icon(
                              Icons.favorite,
                            )
                          : const Icon(
                              Icons.favorite_outline,
                            ),
                    ),
                    Text('${widget.snap.likes.length.toString()} Likes')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => commentsScreen(
                              snap: widget.snap,
                            ),
                          ),
                        )
                            .then((_) {
                          // This block runs when you have returned back to the 1st Page from 2nd.
                          setState(() {
                            // Call setState to refresh the page.
                            getData();
                          });
                        });
                      },
                      icon: const Icon(
                        Icons.comment_outlined,
                      ),
                    ),
                    Text(postLen.toString())
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.save_outlined),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
