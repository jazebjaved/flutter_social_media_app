import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import '../resources/firestore_method.dart';

class commentCard extends StatelessWidget {
  final snap;
  const commentCard({
    super.key,
    this.snap,
  });

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
                  await FirestoreMethods().deleteComment(
                      snap['uid'], snap['postId'], snap['commentId'], context);
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
    return Column(children: [
      Card(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        elevation: 10,
        shadowColor: const Color(0xFFEE0F38),
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
                  CircleAvatar(
                    radius: 17,
                    backgroundImage: NetworkImage(snap['profPic']),
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
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundColor: Color.fromARGB(65, 158, 158, 158),
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
                    padding: EdgeInsets.only(right: 30),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        snap['text'],
                        textAlign: TextAlign.start,
                        style: TextStyle(
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