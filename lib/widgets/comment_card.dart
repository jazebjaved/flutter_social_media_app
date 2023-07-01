import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../resources/firestore_method.dart';

class commentCard extends StatelessWidget {
  final snap;
  final String postOwnerId;
  const commentCard({super.key, this.snap, required this.postOwnerId});

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
                  await FirestoreMethods().deleteComment(snap['uid'],
                      snap['postId'], snap['commentId'], postOwnerId, context);
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Column(children: [
      Card(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        elevation: 3,
        shadowColor: const Color.fromARGB(255, 255, 254, 254),
        child: Container(
          padding: const EdgeInsets.only(
            left: 25,
            right: 15,
            top: 12,
            bottom: 12,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: snap['profPic'],
                      width: 40,
                      height: 40,
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
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snap['name'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 0,
                      ),
                      Text(
                        DateFormat.yMEd()
                            .format(snap['datePublished'].toDate()),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
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
                        Icons.more_horiz,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        snap['text'],
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
