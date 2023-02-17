import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:first_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/message.dart';
import '../resources/chatApi.dart';
import '../widgets/conversation_card.dart';
import '../models/user.dart' as UserModel;

class ChattingScreen extends StatefulWidget {
  final UserModel.User user;
  const ChattingScreen({super.key, required this.user});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  List<Message> _list = [];
  final TextEditingController _chattingController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _chattingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: _appbar(context),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: ChatApi().getAllMessages(widget.user),
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
                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: 18),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ConversationCard(messages: _list[index]);
                              });
                        } else {
                          return const Center(
                            child: Text('Say Hii! 👋',
                                style: TextStyle(fontSize: 20)),
                          );
                        }
                    }
                  }),
            ),
            _chatInput(context)
          ],
        ),
      ),
    );
  }

  Widget _appbar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        Badge(
          position: BadgePosition.bottomEnd(bottom: 5, end: 0),
          badgeStyle: BadgeStyle(badgeColor: Colors.green, elevation: 2),
          child: CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(widget.user.photoUrl),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.user.username,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text(
              'Last User Message',
              style: TextStyle(color: Color.fromARGB(169, 0, 0, 0)),
            ),
          ],
        ),
        const Spacer(),
      ],
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.red,
                      size: 26,
                    ),
                  ),
                  Expanded(
                      child: TextField(
                    controller: _chattingController,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        hintText: 'type something', border: InputBorder.none),
                  )),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.image_outlined,
                      color: Colors.red,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.red,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Color(0xFFEE0F38),
            radius: 24,
            child: MaterialButton(
              onPressed: () {
                if (_chattingController.text.isNotEmpty) {
                  ChatApi().sendMessage(widget.user, _chattingController.text);
                  _chattingController.text = "";
                }
              },
              child: Icon(
                Icons.send_outlined,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        )
      ],
    );
  }
}
