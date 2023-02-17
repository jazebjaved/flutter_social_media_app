import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import '../misc/data_utils.dart';
import '../models/message.dart';
import '../models/user.dart' as UserModel;

import '../resources/chatApi.dart';
import '../screen/chatting_screen.dart';

class ChatUserCard extends StatefulWidget {
  final UserModel.User user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  int _data = 0;

  Future counter() async {
    int data = await ChatApi().getUnreadMessageAmount(widget.user);
    setState(() {
      _data = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    counter();
  }

  @override
  Widget build(BuildContext context) {
    Message? _message;

    return StreamBuilder(
        stream: ChatApi().getLastMessage(widget.user),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            //if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const SizedBox();

            //if some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              final _list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

              if (_list.isNotEmpty) _message = _list[0];

              return Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChattingScreen(user: widget.user)));
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
                        Badge(
                          position: BadgePosition.bottomEnd(bottom: 5, end: 0),
                          badgeStyle: BadgeStyle(
                              badgeColor: Colors.green, elevation: 2),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(widget.user.photoUrl),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.user.username,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Text(
                              _message != null
                                  ? _message!.msg
                                  : widget.user.bio,
                              style: TextStyle(
                                  color: Color.fromARGB(169, 0, 0, 0)),
                            ),
                          ],
                        ),
                        const Spacer(),
                        TextButton(
                            onPressed: counter, child: const Text('refresh')),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (_message?.sent != null)
                              Text(
                                DateUtil.getFormattedTime(
                                    context: context, time: _message!.sent),
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            const SizedBox(
                              height: 1,
                            ),
                            if (_message?.read == '' &&
                                ChatApi().user.uid != _message!.fromId)
                              CircleAvatar(
                                backgroundColor: Color(0xFFEE0F38),
                                radius: 14,
                                child: Text(
                                  _data.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
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

    //
  }
}
