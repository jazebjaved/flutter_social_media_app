import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../misc/data_utils.dart';
import '../models/message.dart';
import '../models/user.dart' as UserModel;

import '../provider/theme_provider.dart';
import '../resources/chatApi.dart';
import '../screen/chatting_screen.dart';

class ChatUserCard extends StatelessWidget {
  final UserModel.User user;
  const ChatUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    int unreadMessageAmount = 0;

    Message? message;

    return StreamBuilder(
        stream: ChatApi().getLastMessage(user),
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: ChatApi().getUnreadMessageAmount(user),
              builder: (context, snapshot2) {
                switch (snapshot.connectionState) {
                  //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const SizedBox();

                  //if some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    final unreadMessageAmount = snapshot2.data?.docs.length;

                    final list =
                        data?.map((e) => Message.fromJson(e.data())).toList() ??
                            [];
                    // _list.sort((a, b) => a.sent.compareTo(b.sent));
                    if (list.isNotEmpty) message = list[0];
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ChattingScreen(user: user)));
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 15,
                            bottom: 15,
                          ),
                          child: Row(
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: user.photoUrl,
                                  width: 50,
                                  height: 50,
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
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.username,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Text(
                                    message != null
                                        ? message!.type == Type.text
                                            ? message!.msg
                                            : 'Image 🖼️ '
                                        : user.bio,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (message?.sent != null)
                                    Text(
                                      DateUtil.getFormattedTime(
                                          context: context,
                                          time: message!.sent),
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  if (message?.read == '' &&
                                      ChatApi().user.uid != message!.fromId)
                                    CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      foregroundColor:
                                          Theme.of(context).primaryColor,
                                      radius: 14,
                                      child: Text(
                                        unreadMessageAmount.toString(),
                                        style: const TextStyle(),
                                      ),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                }
              });
        });

    //
  }
}
